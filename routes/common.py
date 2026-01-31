"""
Common Routes - Shared functionality across roles
"""

from flask import Blueprint, render_template, session, redirect, url_for

bp = Blueprint('common', __name__)

@bp.route('/profile')
def profile():
    """View user profile"""
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    from models.models import User
    user = User.query.get(session['user_id'])
    
    return render_template('common/profile.html', user=user)


@bp.route('/session-info')
def session_info():
    """Debug route: return current session contents (requires login)."""
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    # Return a simple HTML-safe representation for debugging
    items = [f"{k}: {v}" for k, v in session.items()]
    # Also fetch the user's stored role name from the database for comparison
    try:
        from models.models import User
        user = User.query.get(session['user_id'])
        db_role = user.role.role_name if user and user.role else 'N/A'
        items.append(f"db_role: {db_role}")
    except Exception as e:
        items.append(f"db_error: {e}")
    return '<pre>' + '\n'.join(items) + '</pre>'


@bp.route('/debug-nav/<role>')
def debug_nav(role):
    """Return HTML showing which nav links would be shown for the given role (debug only)."""
    r = (role or '').strip().lower()
    links = []
    if r == 'student':
        links = [
            ('Dashboard', url_for('student.dashboard')),
            ('Events', url_for('student.events')),
            ('My Registrations', url_for('student.my_registrations')),
            ('Certificates', url_for('student.my_certificates')),
        ]
    elif r == 'event organizer' or r == 'organizer':
        links = [
            ('Dashboard', url_for('organizer.dashboard')),
            ('Create Event', url_for('organizer.create_event')),
        ]
    elif r == 'hod':
        links = [('Dashboard', url_for('hod.dashboard'))]
    elif r == 'principal':
        links = [('Dashboard', url_for('principal.dashboard'))]
    elif r == 'admin':
        links = [
            ('Dashboard', url_for('admin.dashboard')),
            ('Events', url_for('admin.events')),
            ('Reports', url_for('admin.reports')),
            ('Feedback', url_for('admin.feedback')),
        ]
    else:
        return f"Unknown role: {role}", 400

    html = ['<h3>Navigation for role: ' + role + '</h3>', '<ul>']
    for text, href in links:
        html.append(f'<li><a href="{href}">{text}</a></li>')
    html.append('</ul>')
    return '\n'.join(html)
