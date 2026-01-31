"""
Student Routes - Dashboard, Event Registration, Certificates, Feedback
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash, jsonify, send_file
from models.models import Event, Registration, Attendance, Certificate, Feedback, User, Venue
from models import db
from datetime import datetime, date
from sqlalchemy import or_
from utils.qr_utils import generate_qr_code
from functools import wraps
import os

bp = Blueprint('student', __name__, url_prefix='/student')

def student_required(f):
    """Decorator to require student login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session or session.get('role_name', '').lower() != 'student':
            flash('Access denied', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated_function


@bp.route('/dashboard')
@student_required
def dashboard():
    """Student dashboard - view upcoming approved events"""
    # Get upcoming approved events
    today = date.today()
    upcoming_events = Event.query.filter(
        Event.status == 'approved',
        Event.date >= today
    ).order_by(Event.date, Event.start_time).all()
    
    # Get student's registrations
    student_id = session['user_id']
    registrations = Registration.query.filter_by(student_id=student_id).all()
    registered_event_ids = [r.event_id for r in registrations]
    
    # Get past attended events (include events happening today so attendance marked today shows up)
    past_events = db.session.query(Event).join(Registration).join(Attendance).filter(
        Registration.student_id == student_id,
        Event.date <= today
    ).order_by(Event.date.desc()).all()
    
    # Compute attended event ids for counts and UI
    attended_rows = db.session.query(Registration.event_id).join(Attendance).filter(
        Registration.student_id == student_id
    ).all()
    attended_event_ids = {row[0] for row in attended_rows}

    return render_template('student/dashboard.html', 
                         upcoming_events=upcoming_events,
                         registered_event_ids=registered_event_ids,
                         past_events=past_events,
                         attended_event_ids=attended_event_ids)


@bp.route('/events')
@student_required
def events():
    """View all approved upcoming events"""
    today = date.today()
    organizer_filter = request.args.get('organizer', '')
    mode_filter = request.args.get('mode', '')

    query = Event.query.filter(
        Event.status == 'approved',
        Event.date >= today
    )

    if organizer_filter:
        query = query.filter_by(organizer_id=int(organizer_filter))

    if mode_filter:
        query = query.filter_by(mode=mode_filter)

    events = query.order_by(Event.date, Event.start_time).all()
    
    # Get student's registrations and attended events
    student_id = session['user_id']
    registrations = Registration.query.filter_by(student_id=student_id).all()
    registered_event_ids = [r.event_id for r in registrations]

    # Compute attended event ids for this student but only for events that have ended
    now = datetime.now()
    attended_rows = db.session.query(Registration.event_id, Event.date, Event.end_time).join(Attendance).join(Event, Event.event_id==Registration.event_id).filter(
        Registration.student_id == student_id
    ).all()
    attended_event_ids = set()
    for row in attended_rows:
        ev_date = row[1]
        ev_end = row[2]
        try:
            ev_end_dt = datetime.combine(ev_date, ev_end)
            if now >= ev_end_dt:
                attended_event_ids.add(row[0])
        except Exception:
            # If any data missing, include conservatively
            attended_event_ids.add(row[0])

    organizers = User.query.join(User.role).filter(
        or_(
            User.role.has(role_name='Event Organizer'),
            User.role.has(role_name='Organizer')
        )
    ).order_by(User.full_name.asc()).all()
    
    return render_template('student/events.html', 
                         events=events,
                         registered_event_ids=registered_event_ids,
                         attended_event_ids=attended_event_ids,
                         organizers=organizers,
                         organizer_filter=organizer_filter,
                         mode_filter=mode_filter)


@bp.route('/register/<int:event_id>', methods=['POST'])
@student_required
def register_event(event_id):
    """Register for an event"""
    student_id = session['user_id']
    
    # Check if event exists and is approved
    event = Event.query.get_or_404(event_id)
    if event.status != 'approved':
        flash('This event is not open for registration', 'error')
        return redirect(url_for('student.events'))
    
    # Check if already registered
    existing = Registration.query.filter_by(
        event_id=event_id,
        student_id=student_id
    ).first()
    
    if existing:
        flash('You are already registered for this event', 'warning')
        return redirect(url_for('student.events'))
    
    # Create registration
    registration = Registration(
        event_id=event_id,
        student_id=student_id,
        qr_code='temp'  # Will be updated
    )
    db.session.add(registration)
    db.session.commit()
    
    # Generate QR code
    qr_data, qr_image = generate_qr_code(
        registration.registration_id,
        event_id,
        student_id
    )
    
    # Update QR code
    registration.qr_code = qr_data
    db.session.commit()
    
    flash('Successfully registered for the event!', 'success')
    return redirect(url_for('student.my_registrations'))


@bp.route('/my-registrations')
@student_required
def my_registrations():
    """View my event registrations"""
    student_id = session['user_id']
    
    # Get all registrations with QR codes
    organizer_filter = request.args.get('organizer', '')
    mode_filter = request.args.get('mode', '')
    registrations_query = Registration.query.filter_by(student_id=student_id)

    if organizer_filter or mode_filter:
        registrations_query = registrations_query.join(Event)

    if organizer_filter:
        registrations_query = registrations_query.filter(
            Event.organizer_id == int(organizer_filter)
        )

    if mode_filter:
        registrations_query = registrations_query.filter(
            Event.mode == mode_filter
        )

    registrations = registrations_query.all()
    
    # Generate QR images for display
    registration_data = []
    for reg in registrations:
        # Regenerate QR image for display
        from utils.qr_utils import generate_qr_code
        _, qr_image = generate_qr_code(reg.registration_id, reg.event_id, reg.student_id)
        
        # Check attendance and only mark as attended if event has ended
        attendance = Attendance.query.filter_by(registration_id=reg.registration_id).first()
        attended_flag = False
        if attendance:
            try:
                event_end_dt = datetime.combine(reg.event.date, reg.event.end_time)
                if datetime.now() >= event_end_dt:
                    attended_flag = True
            except Exception:
                attended_flag = True

        registration_data.append({
            'registration': reg,
            'event': reg.event,
            'qr_image': qr_image,
            'attended': attended_flag
        })

    organizers = User.query.join(User.role).filter(
        or_(
            User.role.has(role_name='Event Organizer'),
            User.role.has(role_name='Organizer')
        )
    ).order_by(User.full_name.asc()).all()
    
    return render_template('student/my_registrations.html', 
                         registration_data=registration_data,
                         organizers=organizers,
                         organizer_filter=organizer_filter,
                         mode_filter=mode_filter)


@bp.route('/my-certificates')
@student_required
def my_certificates():
    """View and download certificates"""
    student_id = session['user_id']

    search_query = request.args.get('q', '').strip()
    certificates_query = Certificate.query.filter_by(student_id=student_id)

    if search_query:
        certificates_query = certificates_query.join(Event).filter(
            Event.title.ilike(f"%{search_query}%")
        )

    certificates = certificates_query.order_by(
        Certificate.issued_at.desc()
    ).all()
    
    return render_template('student/certificates.html', 
                           certificates=certificates,
                           search_query=search_query)


@bp.route('/download-certificate/<int:certificate_id>')
@student_required
def download_certificate(certificate_id):
    """Download certificate PDF"""
    student_id = session['user_id']
    
    certificate = Certificate.query.filter_by(
        certificate_id=certificate_id,
        student_id=student_id
    ).first_or_404()
    
    # Get full path
    cert_path = os.path.join('static', certificate.certificate_url)
    
    if os.path.exists(cert_path):
        return send_file(cert_path, as_attachment=True)
    else:
        flash('Certificate file not found', 'error')
        return redirect(url_for('student.my_certificates'))


@bp.route('/submit-feedback/<int:event_id>', methods=['GET', 'POST'])
@student_required
def submit_feedback(event_id):
    """Submit feedback for attended event"""
    student_id = session['user_id']
    
    # Check if student attended the event
    registration = Registration.query.filter_by(
        event_id=event_id,
        student_id=student_id
    ).first()
    
    if not registration:
        flash('You must be registered for the event to submit feedback', 'error')
        return redirect(url_for('student.dashboard'))
    
    attendance = Attendance.query.filter_by(registration_id=registration.registration_id).first()
    
    if not attendance:
        flash('You must attend the event to submit feedback', 'error')
        return redirect(url_for('student.dashboard'))

    # Only allow feedback after the event ends
    try:
        event = Event.query.get(event_id)
        event_end_dt = datetime.combine(event.date, event.end_time)
        if datetime.now() < event_end_dt:
            flash('Feedback is available only after the event has ended', 'error')
            return redirect(url_for('student.dashboard'))
    except Exception:
        # If we cannot determine event end, disallow feedback to be safe
        flash('Feedback is available only after the event has ended', 'error')
        return redirect(url_for('student.dashboard'))
    
    # Check if feedback already submitted
    existing_feedback = Feedback.query.filter_by(
        event_id=event_id,
        student_id=student_id
    ).first()
    
    if request.method == 'POST':
        rating = request.form.get('rating')
        comments = request.form.get('comments')
        
        if existing_feedback:
            # Update existing feedback
            existing_feedback.rating = int(rating)
            existing_feedback.comments = comments
        else:
            # Create new feedback
            feedback = Feedback(
                event_id=event_id,
                student_id=student_id,
                rating=int(rating),
                comments=comments
            )
            db.session.add(feedback)
        
        db.session.commit()
        flash('Feedback submitted successfully!', 'success')
        return redirect(url_for('student.dashboard'))
    
    event = Event.query.get_or_404(event_id)
    return render_template('student/feedback.html', 
                         event=event, 
                         existing_feedback=existing_feedback)
