"""
Event Organizer Routes - Create Events, Manage Registrations, QR Scanning
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash, jsonify, current_app
from models.models import Event, Venue, Department, Registration, Attendance, User, Approval, Certificate
from models import db
from datetime import datetime, date
from functools import wraps
from utils.certificate_generator import generate_certificate
import os
from werkzeug.utils import secure_filename

bp = Blueprint('organizer', __name__, url_prefix='/organizer')

def organizer_required(f):
    """Decorator to require organizer login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session or session.get('role_name', '').lower() not in ('event organizer', 'organizer'):
            flash('Access denied', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated_function


@bp.route('/dashboard')
@organizer_required
def dashboard():
    """Organizer dashboard"""
    organizer_id = session['user_id']
    
    # Get organizer's events
    events = Event.query.filter_by(organizer_id=organizer_id).order_by(
        Event.created_at.desc()
    ).all()
    
    # Count statistics
    pending_count = Event.query.filter_by(organizer_id=organizer_id, status='pending').count()
    approved_count = Event.query.filter_by(organizer_id=organizer_id, status='approved').count()
    rejected_count = Event.query.filter_by(organizer_id=organizer_id, status='rejected').count()
    
    return render_template('organizer/dashboard.html',
                         events=events,
                         pending_count=pending_count,
                         approved_count=approved_count,
                         rejected_count=rejected_count)


@bp.route('/create-event', methods=['GET', 'POST'])
@organizer_required
def create_event():
    """Create new event"""
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        event_date = datetime.strptime(request.form.get('date'), '%Y-%m-%d').date()
        start_time = datetime.strptime(request.form.get('start_time'), '%H:%M').time()
        end_time = datetime.strptime(request.form.get('end_time'), '%H:%M').time()
        venue_id = request.form.get('venue_id')
        mode = request.form.get('mode') or 'offline'
        meeting_url = request.form.get('meeting_url')
        dept_id = request.form.get('dept_id')
        poster_file = request.files.get('poster')
        
        # Validation
        if event_date < date.today():
            flash('Event date cannot be in the past', 'error')
            return redirect(url_for('organizer.create_event'))
        
        if start_time >= end_time:
            flash('End time must be after start time', 'error')
            return redirect(url_for('organizer.create_event'))
        
        # Create event
        # If online, venue may be empty and meeting_url required
        if (mode or '').lower() == 'online':
            if not meeting_url:
                flash('Meeting URL is required for online events', 'error')
                return redirect(url_for('organizer.create_event'))
            # treat '0' or missing as no venue
            venue_val = int(venue_id) if venue_id and int(venue_id) > 0 else None
        else:
            # offline: venue required
            if not venue_id or int(venue_id) <= 0:
                flash('Venue is required for offline events', 'error')
                return redirect(url_for('organizer.create_event'))
            venue_val = int(venue_id)

        # If offline and venue selected, ensure the venue is not already booked
        if (mode or '').lower() != 'online' and venue_val is not None:
            conflict = Event.query.filter(
                Event.venue_id == venue_val,
                Event.date == event_date,
                Event.status.in_(['pending', 'approved']),
                Event.start_time < end_time,
                Event.end_time > start_time
            ).first()
            if conflict:
                flash('Selected venue is already booked for the chosen date/time', 'error')
                return redirect(url_for('organizer.create_event'))

        poster_url = None
        if poster_file and poster_file.filename:
            filename = secure_filename(poster_file.filename)
            ext = os.path.splitext(filename)[1].lower()
            allowed_exts = {'.jpg', '.jpeg', '.png', '.webp'}
            if ext not in allowed_exts:
                flash('Poster must be a JPG, PNG, or WEBP image', 'error')
                return redirect(url_for('organizer.create_event'))

            safe_name = f"event_{session['user_id']}_{int(datetime.utcnow().timestamp())}{ext}"
            poster_dir = os.path.join(current_app.config['UPLOAD_FOLDER'], 'events')
            os.makedirs(poster_dir, exist_ok=True)
            poster_path = os.path.join(poster_dir, safe_name)
            poster_file.save(poster_path)
            poster_url = os.path.join('uploads', 'events', safe_name)

        event = Event(
            title=title,
            description=description,
            date=event_date,
            start_time=start_time,
            end_time=end_time,
            venue_id=venue_val,
            dept_id=int(dept_id) if dept_id else None,
            organizer_id=session['user_id'],
            status='pending',
            mode=(mode or 'offline'),
            meeting_url=meeting_url if meeting_url else None,
            poster_url=poster_url
        )
        
        # Validate venue FK before committing: ensure it references an existing venue
        if event.venue_id is not None:
            existing_venue = Venue.query.get(event.venue_id)
            if not existing_venue:
                # If mode is online, allow missing venue by setting NULL; otherwise reject
                if (event.mode or '').lower() == 'online':
                    event.venue_id = None
                else:
                    flash('Selected venue was not found. Please pick a valid venue.', 'error')
                    return redirect(url_for('organizer.create_event'))

        db.session.add(event)
        try:
            db.session.commit()
        except Exception:
            db.session.rollback()
            flash('Failed to create event due to database error.', 'error')
            return redirect(url_for('organizer.create_event'))
        
        # Create approval workflow
        # Determine department to check for HOD approval: prefer venue.dept_id if venue provided,
        # otherwise use the dept selected on the form (useful for online events tied to a dept)
        venue = Venue.query.get(venue_val) if venue_val else None
        dept_to_check = None
        if venue and venue.dept_id:
            dept_to_check = venue.dept_id
        else:
            try:
                dept_to_check = int(dept_id) if dept_id else None
            except Exception:
                dept_to_check = None

        # If there's a department to check, find HOD and create HOD approval
        if dept_to_check:
            hod = User.query.join(User.role).filter(
                User.dept_id == dept_to_check,
                User.role.has(role_name='HOD')
            ).first()
            if hod:
                approval = Approval(
                    event_id=event.event_id,
                    approver_id=hod.user_id,
                    approver_role='HOD'
                )
                db.session.add(approval)
        
        # Always create Principal approval entry (will be pending until HOD approves if needed)
        principal = User.query.join(User.role).filter(
            User.role.has(role_name='Principal')
        ).first()
        
        if principal:
            principal_approval = Approval(
                event_id=event.event_id,
                approver_id=principal.user_id,
                approver_role='Principal'
            )
            db.session.add(principal_approval)
        
        db.session.commit()
        
        flash('Event created and submitted for approval!', 'success')
        return redirect(url_for('organizer.dashboard'))
    
    # Get venues and departments
    venues = Venue.query.all()
    departments = Department.query.all()
    
    return render_template('organizer/create_event.html',
                         venues=venues,
                         departments=departments)


@bp.route('/event/<int:event_id>/edit', methods=['GET', 'POST'])
@organizer_required
def edit_event(event_id):
    """Edit an existing event"""
    organizer_id = session['user_id']
    event = Event.query.filter_by(event_id=event_id, organizer_id=organizer_id).first_or_404()

    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        event_date = datetime.strptime(request.form.get('date'), '%Y-%m-%d').date()
        start_time = datetime.strptime(request.form.get('start_time'), '%H:%M').time()
        end_time = datetime.strptime(request.form.get('end_time'), '%H:%M').time()
        venue_id = request.form.get('venue_id')
        mode = request.form.get('mode') or 'offline'
        meeting_url = request.form.get('meeting_url')
        dept_id = request.form.get('dept_id')

        if event_date < date.today():
            flash('Event date cannot be in the past', 'error')
            return redirect(url_for('organizer.edit_event', event_id=event_id))

        if start_time >= end_time:
            flash('End time must be after start time', 'error')
            return redirect(url_for('organizer.edit_event', event_id=event_id))

        if (mode or '').lower() == 'online':
            if not meeting_url:
                flash('Meeting URL is required for online events', 'error')
                return redirect(url_for('organizer.edit_event', event_id=event_id))
            venue_val = int(venue_id) if venue_id and int(venue_id) > 0 else None
        else:
            if not venue_id or int(venue_id) <= 0:
                flash('Venue is required for offline events', 'error')
                return redirect(url_for('organizer.edit_event', event_id=event_id))
            venue_val = int(venue_id)

        if (mode or '').lower() != 'online' and venue_val is not None:
            conflict = Event.query.filter(
                Event.venue_id == venue_val,
                Event.date == event_date,
                Event.status.in_(['pending', 'approved']),
                Event.start_time < end_time,
                Event.end_time > start_time,
                Event.event_id != event.event_id
            ).first()
            if conflict:
                flash('Selected venue is already booked for the chosen date/time', 'error')
                return redirect(url_for('organizer.edit_event', event_id=event_id))

        requires_reapproval = (
            event.date != event_date or
            event.start_time != start_time or
            event.end_time != end_time or
            (event.venue_id or None) != venue_val or
            (event.mode or 'offline') != (mode or 'offline') or
            (event.meeting_url or None) != (meeting_url or None) or
            (event.dept_id or None) != (int(dept_id) if dept_id else None)
        )

        event.title = title
        event.description = description
        event.date = event_date
        event.start_time = start_time
        event.end_time = end_time
        event.venue_id = venue_val
        event.dept_id = int(dept_id) if dept_id else None
        event.mode = (mode or 'offline')
        event.meeting_url = meeting_url if meeting_url else None

        if requires_reapproval:
            event.status = 'pending'
            Approval.query.filter_by(event_id=event.event_id).delete()

            venue = Venue.query.get(venue_val) if venue_val else None
            dept_to_check = venue.dept_id if venue and venue.dept_id else event.dept_id
            if dept_to_check:
                hod = User.query.join(User.role).filter(
                    User.dept_id == dept_to_check,
                    User.role.has(role_name='HOD')
                ).first()
                if hod:
                    db.session.add(Approval(
                        event_id=event.event_id,
                        approver_id=hod.user_id,
                        approver_role='HOD',
                        status='pending',
                        remarks='Event updated (not new). Approval required.'
                    ))

            principal = User.query.join(User.role).filter(
                User.role.has(role_name='Principal')
            ).first()
            if principal:
                db.session.add(Approval(
                    event_id=event.event_id,
                    approver_id=principal.user_id,
                    approver_role='Principal',
                    status='pending',
                    remarks='Event updated (not new). Approval required.'
                ))

            flash('Event updated and re-submitted for approval (not a new event).', 'success')
        else:
            flash('Event updated successfully.', 'success')

        db.session.commit()
        return redirect(url_for('organizer.view_event', event_id=event.event_id))

    venues = Venue.query.all()
    departments = Department.query.all()
    return render_template('organizer/edit_event.html', event=event, venues=venues, departments=departments)


@bp.route('/event/<int:event_id>/delete', methods=['POST'])
@organizer_required
def delete_event(event_id):
    """Delete an event"""
    organizer_id = session['user_id']
    event = Event.query.filter_by(event_id=event_id, organizer_id=organizer_id).first_or_404()
    db.session.delete(event)
    db.session.commit()
    flash('Event deleted successfully.', 'success')
    return redirect(url_for('organizer.dashboard'))


@bp.route('/event/<int:event_id>')
@organizer_required
def view_event(event_id):
    """View event details and registrations"""
    organizer_id = session['user_id']
    
    event = Event.query.filter_by(
        event_id=event_id,
        organizer_id=organizer_id
    ).first_or_404()
    
    # Get registrations
    registrations = Registration.query.filter_by(event_id=event_id).all()
    
    # Get attendance count
    attended_count = db.session.query(Attendance).join(Registration).filter(
        Registration.event_id == event_id
    ).count()
    
    # Get approvals
    approvals = Approval.query.filter_by(event_id=event_id).order_by(
        Approval.approved_at
    ).all()
    
    return render_template('organizer/view_event.html',
                         event=event,
                         registrations=registrations,
                         attended_count=attended_count,
                         approvals=approvals)


@bp.route('/scan-qr/<int:event_id>')
@organizer_required
def scan_qr(event_id):
    """QR code scanning interface"""
    organizer_id = session['user_id']
    
    event = Event.query.filter_by(
        event_id=event_id,
        organizer_id=organizer_id
    ).first_or_404()
    
    return render_template('organizer/scan_qr.html', event=event)


@bp.route('/validate-qr', methods=['POST'])
@organizer_required
def validate_qr():
    """Validate QR code and mark attendance"""
    data = request.get_json()
    qr_code = data.get('qr_code')
    event_id = data.get('event_id')
    
    # Validate QR code format
    from utils.qr_utils import validate_qr_code
    qr_info = validate_qr_code(qr_code)
    
    if not qr_info:
        return jsonify({'success': False, 'message': 'Invalid QR code format'})
    
    # Find registration
    registration = Registration.query.filter_by(qr_code=qr_code).first()
    
    if not registration:
        return jsonify({'success': False, 'message': 'Registration not found'})
    
    # Verify event matches
    if registration.event_id != int(event_id):
        return jsonify({'success': False, 'message': 'QR code is for a different event'})

    # Disallow marking attendance before the event start time
    try:
        event_obj = Event.query.get(registration.event_id)
        event_start_dt = datetime.combine(event_obj.date, event_obj.start_time)
        if datetime.now() < event_start_dt:
            return jsonify({'success': False, 'message': 'Cannot mark attendance before event start time'})
    except Exception:
        # If we cannot determine event time, allow normal processing to continue
        pass
    
    # Check if already scanned
    existing_attendance = Attendance.query.filter_by(
        registration_id=registration.registration_id
    ).first()
    
    if existing_attendance:
        return jsonify({
            'success': False, 
            'message': 'Already marked present',
            'student_name': registration.student.full_name,
            'scan_time': existing_attendance.scan_time.strftime('%Y-%m-%d %H:%M:%S')
        })
    
    # Mark attendance
    attendance = Attendance(
        registration_id=registration.registration_id,
        scan_time=datetime.now(),
        scanned_by=session['user_id'],
        status='present'
    )
    try:
        # Attach to registration to keep ORM relationship consistent
        registration.attendance = attendance
        db.session.add(attendance)
        db.session.add(registration)
        db.session.commit()
    except Exception:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'Failed to mark attendance (DB error)'}), 500

    # Generate certificate after marking attendance
    generate_certificate_for_student(registration.student_id, registration.event_id)
    
    return jsonify({
        'success': True,
        'message': 'Attendance marked successfully',
        'student_name': registration.student.full_name,
        'student_email': registration.student.email
    })


def generate_certificate_for_student(student_id, event_id):
    """Generate certificate after attendance is marked"""
    # Check if certificate already exists
    existing_cert = Certificate.query.filter_by(
        student_id=student_id,
        event_id=event_id
    ).first()
    
    if existing_cert:
        return
    
    # Get student and event details
    student = User.query.get(student_id)
    event = Event.query.get(event_id)
    
    # Generate certificate filename
    filename = f"cert_{student_id}_{event_id}_{datetime.now().strftime('%Y%m%d%H%M%S')}.pdf"
    cert_path = os.path.join('static', 'uploads', 'certificates', filename)
    
    # Ensure directory exists
    os.makedirs(os.path.dirname(cert_path), exist_ok=True)
    
    # Generate PDF
    from utils.certificate_generator import generate_certificate
    generate_certificate(
        student_name=student.full_name,
        event_title=event.title,
        event_date=event.date.strftime('%B %d, %Y'),
        organizer_name=event.organizer.full_name,
        output_path=cert_path
    )
    
    # Save certificate record
    certificate = Certificate(
        student_id=student_id,
        event_id=event_id,
        certificate_url=f'uploads/certificates/{filename}'
    )
    db.session.add(certificate)
    db.session.commit()


@bp.route('/mark-attendance/<int:registration_id>', methods=['POST'])
@organizer_required
def mark_attendance(registration_id):
    """Manually mark attendance for a registration (used for online events)"""
    organizer_id = session['user_id']
    # Find registration and event
    registration = Registration.query.get_or_404(registration_id)
    event = Event.query.get_or_404(registration.event_id)

    # Ensure organizer owns the event
    if event.organizer_id != organizer_id:
        flash('Access denied', 'error')
        return redirect(url_for('organizer.view_event', event_id=event.event_id))

    # Only allow manual marking for online events (or still allow if organizer wants)
    # We'll allow it but prefer online check
    if (event.mode or '').lower() == 'offline':
        # still allow but warn
        flash('Manual marking is intended for online events. Proceeding.', 'warning')

    # Check if already marked
    existing = Attendance.query.join(Registration).filter(
        Attendance.registration_id == registration.registration_id
    ).first()
    if existing:
        flash('Attendance already marked for this registration', 'info')
        return redirect(url_for('organizer.view_event', event_id=event.event_id))

    # Prevent marking before event start time
    try:
        event_start = datetime.combine(event.date, event.start_time)
        if datetime.now() < event_start:
            flash('Cannot mark attendance before the event start time', 'error')
            return redirect(url_for('organizer.view_event', event_id=event.event_id))
    except Exception:
        # ignore and allow marking if we cannot compute start
        pass

    # Mark attendance
    attendance = Attendance(
        registration_id=registration.registration_id,
        scan_time=datetime.now(),
        scanned_by=organizer_id,
        status='present'
    )
    try:
        # Attach attendance to the registration relationship to keep ORM state consistent
        registration.attendance = attendance
        db.session.add(attendance)
        db.session.add(registration)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        flash('Failed to mark attendance due to database error.', 'error')
        return redirect(url_for('organizer.view_event', event_id=event.event_id))

    # Refresh registration and attendance objects to ensure relationship is available
    try:
        db.session.refresh(registration)
        db.session.refresh(attendance)
    except Exception:
        # If refresh fails, ignore - the redirect will re-query on the next request
        pass

    # Generate certificate
    generate_certificate_for_student(registration.student_id, registration.event_id)

    flash('Attendance marked successfully', 'success')
    return redirect(url_for('organizer.view_event', event_id=event.event_id))
