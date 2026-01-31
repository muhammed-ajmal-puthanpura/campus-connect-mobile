"""
Admin Routes - Analytics, Reports, System Overview
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash, send_file
from models.models import Event, Registration, Attendance, Feedback, User, Department, Venue
from models import db
from datetime import datetime, date, timedelta
from functools import wraps
from sqlalchemy import func, or_
from io import BytesIO
from reportlab.lib.pagesizes import landscape, letter
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.units import inch
from openpyxl import Workbook

bp = Blueprint('admin', __name__, url_prefix='/admin')

def admin_required(f):
    """Decorator to require admin login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session or session.get('role_name', '').lower() != 'admin':
            flash('Access denied', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated_function


@bp.route('/dashboard')
@admin_required
def dashboard():
    """Admin dashboard with overview statistics"""
    # Overall statistics
    total_events = Event.query.count()
    approved_events = Event.query.filter_by(status='approved').count()
    pending_events = Event.query.filter_by(status='pending').count()
    total_students = User.query.join(User.role).filter(User.role.has(role_name='Student')).count()
    total_registrations = Registration.query.count()
    total_attendance = Attendance.query.count()
    
    # Recent events
    recent_events = Event.query.order_by(Event.created_at.desc()).limit(10).all()
    
    # Department-wise statistics
    dept_stats = db.session.query(
        Department.dept_name,
        func.count(Event.event_id).label('event_count')
    ).join(Event).group_by(Department.dept_id).all()
    
    # Upcoming events
    upcoming_events = Event.query.filter(
        Event.status == 'approved',
        Event.date >= date.today()
    ).order_by(Event.date).limit(5).all()
    
    return render_template('admin/dashboard.html',
                         total_events=total_events,
                         approved_events=approved_events,
                         pending_events=pending_events,
                         total_students=total_students,
                         total_registrations=total_registrations,
                         total_attendance=total_attendance,
                         recent_events=recent_events,
                         dept_stats=dept_stats,
                         upcoming_events=upcoming_events)


@bp.route('/events')
@admin_required
def events():
    """View all events with filters"""
    # Get filter parameters
    status_filter = request.args.get('status', '')
    dept_filter = request.args.get('department', '')
    organizer_filter = request.args.get('organizer', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Build query
    query = Event.query
    
    if status_filter:
        query = query.filter_by(status=status_filter)
    
    if dept_filter:
        query = query.filter_by(dept_id=int(dept_filter))

    if organizer_filter:
        query = query.filter_by(organizer_id=int(organizer_filter))
    
    if date_from:
        query = query.filter(Event.date >= datetime.strptime(date_from, '%Y-%m-%d').date())
    
    if date_to:
        query = query.filter(Event.date <= datetime.strptime(date_to, '%Y-%m-%d').date())
    
    events = query.order_by(Event.date.desc()).all()
    
    # Get departments for filter
    departments = Department.query.all()
    organizers = User.query.join(User.role).filter(
        or_(
            User.role.has(role_name='Event Organizer'),
            User.role.has(role_name='Organizer')
        )
    ).order_by(User.full_name.asc()).all()
    
    return render_template('admin/events.html',
                         events=events,
                         departments=departments,
                         organizers=organizers,
                         status_filter=status_filter,
                         dept_filter=dept_filter,
                         organizer_filter=organizer_filter,
                         date_from=date_from,
                         date_to=date_to)


@bp.route('/events/export')
@admin_required
def export_events():
    """Export filtered events to Excel or PDF"""
    status_filter = request.args.get('status', '')
    dept_filter = request.args.get('department', '')
    organizer_filter = request.args.get('organizer', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    export_format = (request.args.get('format') or 'xlsx').lower()

    query = Event.query

    if status_filter:
        query = query.filter_by(status=status_filter)

    if dept_filter:
        query = query.filter_by(dept_id=int(dept_filter))

    if organizer_filter:
        query = query.filter_by(organizer_id=int(organizer_filter))

    if date_from:
        query = query.filter(Event.date >= datetime.strptime(date_from, '%Y-%m-%d').date())

    if date_to:
        query = query.filter(Event.date <= datetime.strptime(date_to, '%Y-%m-%d').date())

    events = query.order_by(Event.date.desc()).all()

    if export_format == 'pdf':
        buffer = BytesIO()
        c = canvas.Canvas(buffer, pagesize=landscape(letter))
        width, height = landscape(letter)

        c.setFont('Helvetica-Bold', 16)
        c.drawString(0.6 * inch, height - 0.6 * inch, 'Events Report')

        headers = ['Title', 'Date', 'Status', 'Department', 'Organizer']
        col_widths = [3.2 * inch, 1.4 * inch, 1.2 * inch, 2.0 * inch, 2.0 * inch]
        start_x = 0.6 * inch
        start_y = height - 1.1 * inch
        row_height = 0.35 * inch

        c.setFillColor(colors.HexColor('#1f2937'))
        c.setFont('Helvetica-Bold', 10)
        x = start_x
        for idx, header in enumerate(headers):
            c.drawString(x + 4, start_y, header)
            x += col_widths[idx]

        c.setStrokeColor(colors.HexColor('#e5e7eb'))
        y = start_y - row_height
        c.setFont('Helvetica', 9)
        for event in events:
            if y < 0.7 * inch:
                c.showPage()
                y = height - 0.8 * inch
            values = [
                event.title,
                event.date.strftime('%Y-%m-%d'),
                event.status,
                event.department.dept_name if event.department else '—',
                event.organizer.full_name if event.organizer else '—'
            ]
            x = start_x
            for idx, value in enumerate(values):
                c.drawString(x + 4, y, str(value))
                x += col_widths[idx]
            y -= row_height

        c.save()
        buffer.seek(0)
        return send_file(
            buffer,
            as_attachment=True,
            download_name='events_report.pdf',
            mimetype='application/pdf'
        )

    wb = Workbook()
    ws = wb.active
    ws.title = 'Events'
    ws.append(['Title', 'Date', 'Status', 'Department', 'Organizer'])
    for event in events:
        ws.append([
            event.title,
            event.date.strftime('%Y-%m-%d'),
            event.status,
            event.department.dept_name if event.department else '—',
            event.organizer.full_name if event.organizer else '—'
        ])

    output = BytesIO()
    wb.save(output)
    output.seek(0)
    return send_file(
        output,
        as_attachment=True,
        download_name='events_report.xlsx',
        mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )


@bp.route('/event/<int:event_id>')
@admin_required
def view_event(event_id):
    """View detailed event information"""
    event = Event.query.get_or_404(event_id)
    
    # Get registrations
    registrations = Registration.query.filter_by(event_id=event_id).all()
    
    # Get attendance
    attendance_records = db.session.query(Attendance).join(Registration).filter(
        Registration.event_id == event_id
    ).all()
    
    # Get feedback
    feedback_records = Feedback.query.filter_by(event_id=event_id).all()
    
    # Calculate average rating
    avg_rating = db.session.query(func.avg(Feedback.rating)).filter_by(
        event_id=event_id
    ).scalar() or 0
    
    return render_template('admin/view_event.html',
                         event=event,
                         registrations=registrations,
                         attendance_records=attendance_records,
                         feedback_records=feedback_records,
                         avg_rating=round(avg_rating, 2))


@bp.route('/reports')
@admin_required
def reports():
    """Generate various reports"""
    # Monthly event statistics
    current_month = date.today().replace(day=1)
    events_this_month = Event.query.filter(
        Event.date >= current_month
    ).count()
    
    # Student participation statistics
    top_students = db.session.query(
        User.full_name,
        User.email,
        func.count(Registration.registration_id).label('event_count')
    ).join(Registration).filter(
        User.role.has(role_name='Student')
    ).group_by(User.user_id).order_by(func.count(Registration.registration_id).desc()).limit(10).all()
    
    # Event organizer statistics
    top_organizers = db.session.query(
        User.full_name,
        User.email,
        func.count(Event.event_id).label('event_count')
    ).join(Event, User.user_id == Event.organizer_id).group_by(User.user_id).order_by(
        func.count(Event.event_id).desc()
    ).limit(10).all()

    organizer_feedback = db.session.query(
        User.full_name,
        User.email,
        func.avg(Feedback.rating).label('avg_rating'),
        func.count(Feedback.feedback_id).label('feedback_count')
    ).join(Event, Event.organizer_id == User.user_id).join(
        Feedback, Feedback.event_id == Event.event_id
    ).group_by(User.user_id).order_by(func.avg(Feedback.rating).desc()).limit(10).all()
    
    # Department-wise participation
    dept_participation = db.session.query(
        Department.dept_name,
        func.count(Registration.registration_id).label('registration_count')
    ).join(User, User.dept_id == Department.dept_id).join(
        Registration, Registration.student_id == User.user_id
    ).group_by(Department.dept_id).all()
    
    # Feedback summary
    feedback_summary = db.session.query(
        Feedback.rating,
        func.count(Feedback.feedback_id).label('count')
    ).group_by(Feedback.rating).all()
    
    return render_template('admin/reports.html',
                         events_this_month=events_this_month,
                         top_students=top_students,
                         top_organizers=top_organizers,
                         organizer_feedback=organizer_feedback,
                         dept_participation=dept_participation,
                         feedback_summary=feedback_summary)


@bp.route('/reports/export')
@admin_required
def export_reports():
    """Export reports to Excel or PDF"""
    export_format = (request.args.get('format') or 'xlsx').lower()

    top_students = db.session.query(
        User.full_name,
        User.email,
        func.count(Registration.registration_id).label('event_count')
    ).join(Registration).filter(
        User.role.has(role_name='Student')
    ).group_by(User.user_id).order_by(func.count(Registration.registration_id).desc()).limit(10).all()

    top_organizers = db.session.query(
        User.full_name,
        User.email,
        func.count(Event.event_id).label('event_count')
    ).join(Event, User.user_id == Event.organizer_id).group_by(User.user_id).order_by(
        func.count(Event.event_id).desc()
    ).limit(10).all()

    organizer_feedback = db.session.query(
        User.full_name,
        User.email,
        func.avg(Feedback.rating).label('avg_rating'),
        func.count(Feedback.feedback_id).label('feedback_count')
    ).join(Event, Event.organizer_id == User.user_id).join(
        Feedback, Feedback.event_id == Event.event_id
    ).group_by(User.user_id).order_by(func.avg(Feedback.rating).desc()).limit(10).all()

    if export_format == 'pdf':
        buffer = BytesIO()
        c = canvas.Canvas(buffer, pagesize=landscape(letter))
        width, height = landscape(letter)
        y = height - 0.6 * inch

        c.setFont('Helvetica-Bold', 16)
        c.drawString(0.6 * inch, y, 'Reports & Analytics')
        y -= 0.5 * inch

        def draw_table(title, headers, rows):
            nonlocal y
            if y < 1.4 * inch:
                c.showPage()
                y = height - 0.8 * inch
            c.setFont('Helvetica-Bold', 12)
            c.drawString(0.6 * inch, y, title)
            y -= 0.3 * inch

            c.setFont('Helvetica-Bold', 9)
            x = 0.6 * inch
            col_widths = [2.6 * inch, 2.6 * inch, 1.6 * inch, 1.6 * inch]
            for idx, header in enumerate(headers):
                c.drawString(x + 2, y, header)
                x += col_widths[idx]
            y -= 0.3 * inch

            c.setFont('Helvetica', 9)
            for row in rows:
                if y < 0.8 * inch:
                    c.showPage()
                    y = height - 0.8 * inch
                x = 0.6 * inch
                for idx, value in enumerate(row):
                    c.drawString(x + 2, y, str(value))
                    x += col_widths[idx]
                y -= 0.28 * inch

            y -= 0.2 * inch

        draw_table(
            'Top Participating Students',
            ['Name', 'Email', 'Events Attended', ''],
            [(s[0], s[1], s[2], '') for s in top_students]
        )

        draw_table(
            'Most Active Organizers',
            ['Name', 'Email', 'Events Created', ''],
            [(o[0], o[1], o[2], '') for o in top_organizers]
        )

        draw_table(
            'Best Rated Organizers (Feedback)',
            ['Name', 'Email', 'Avg Rating', 'Feedback Count'],
            [(o[0], o[1], f"{(o[2] or 0):.2f}", o[3]) for o in organizer_feedback]
        )

        c.save()
        buffer.seek(0)
        return send_file(
            buffer,
            as_attachment=True,
            download_name='reports_analytics.pdf',
            mimetype='application/pdf'
        )

    wb = Workbook()
    ws_students = wb.active
    ws_students.title = 'Top Students'
    ws_students.append(['Name', 'Email', 'Events Attended'])
    for student in top_students:
        ws_students.append([student[0], student[1], student[2]])

    ws_org = wb.create_sheet('Active Organizers')
    ws_org.append(['Name', 'Email', 'Events Created'])
    for org in top_organizers:
        ws_org.append([org[0], org[1], org[2]])

    ws_feedback = wb.create_sheet('Best Organizers')
    ws_feedback.append(['Name', 'Email', 'Avg Rating', 'Feedback Count'])
    for org in organizer_feedback:
        ws_feedback.append([org[0], org[1], float(org[2] or 0), org[3]])

    output = BytesIO()
    wb.save(output)
    output.seek(0)
    return send_file(
        output,
        as_attachment=True,
        download_name='reports_analytics.xlsx',
        mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )


@bp.route('/feedback')
@admin_required
def feedback():
    """View all feedback"""
    # Get all feedback with event and student details
    all_feedback = Feedback.query.order_by(Feedback.submitted_at.desc()).all()
    
    # Calculate overall statistics
    total_feedback = Feedback.query.count()
    avg_rating = db.session.query(func.avg(Feedback.rating)).scalar() or 0
    
    return render_template('admin/feedback.html',
                         all_feedback=all_feedback,
                         total_feedback=total_feedback,
                         avg_rating=round(avg_rating, 2))


@bp.route('/users')
@admin_required
def users():
    """View all users"""
    users = User.query.all()
    return render_template('admin/users.html', users=users)
