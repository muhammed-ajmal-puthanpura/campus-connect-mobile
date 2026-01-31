"""
Authentication Routes - Login, Logout, Registration
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models.models import User, Role, Department
from models import db

bp = Blueprint('auth', __name__, url_prefix='/auth')

@bp.route('/login', methods=['GET', 'POST'])
def login():
    """User login"""
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        # Find user
        user = User.query.filter_by(email=email).first()
        
        if user and user.check_password(password):
            # Set session
            session.permanent = True
            session['user_id'] = user.user_id
            session['full_name'] = user.full_name
            session['email'] = user.email
            session['role_id'] = user.role_id
            # Normalize and canonicalize role name for session and redirects
            role_raw = (user.role.role_name or '').strip().lower()
            display_map = {
                'student': 'Student',
                'event organizer': 'Event Organizer',
                'organizer': 'Event Organizer',
                'hod': 'HOD',
                'principal': 'Principal',
                'admin': 'Admin'
            }
            session['role_name'] = display_map.get(role_raw, (user.role.role_name or '').title())
            session['dept_id'] = user.dept_id

            # Redirect based on normalized role
            if role_raw == 'student':
                return redirect(url_for('student.dashboard'))
            elif role_raw in ('event organizer', 'organizer'):
                return redirect(url_for('organizer.dashboard'))
            elif role_raw == 'hod':
                return redirect(url_for('hod.dashboard'))
            elif role_raw == 'principal':
                return redirect(url_for('principal.dashboard'))
            elif role_raw == 'admin':
                return redirect(url_for('admin.dashboard'))
        else:
            flash('Invalid email or password', 'error')
    
    return render_template('auth/login.html')


@bp.route('/register', methods=['GET', 'POST'])
def register():
    """User registration"""
    if request.method == 'POST':
        full_name = request.form.get('full_name')
        email = request.form.get('email')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        role_id = request.form.get('role_id')
        dept_id = request.form.get('dept_id')
        
        # Validation
        if len(password or '') < 8:
            flash('Password must be at least 8 characters.', 'error')
            return redirect(url_for('auth.register'))

        if password != confirm_password:
            flash('Passwords do not match', 'error')
            return redirect(url_for('auth.register'))
        
        # Check if email exists
        if User.query.filter_by(email=email).first():
            flash('Email already registered', 'error')
            return redirect(url_for('auth.register'))
        
        # Create user
        user = User(
            full_name=full_name,
            email=email,
            role_id=int(role_id),
            dept_id=int(dept_id) if dept_id else None
        )
        user.set_password(password)
        
        db.session.add(user)
        db.session.commit()
        
        flash('Registration successful! Please login.', 'success')
        return redirect(url_for('auth.login'))
    
    # Get roles and departments for form
    roles = Role.query.all()
    departments = Department.query.all()
    
    return render_template('auth/register.html', roles=roles, departments=departments)


@bp.route('/logout')
def logout():
    """User logout"""
    session.clear()
    flash('Logged out successfully', 'success')
    return redirect(url_for('auth.login'))

@bp.route('/signup', methods=['GET', 'POST'])
def signup():
    """Signup disabled — redirect to login."""
    flash('Registration is disabled. Please contact the administrator.', 'warning')
    return redirect(url_for('auth.login'))

@bp.route('/change-password', methods=['GET', 'POST'])
def change_password():
    """Change password for logged-in users"""
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))
    
    if request.method == 'POST':
        old_password = request.form.get('old_password')
        new_password = request.form.get('new_password')
        confirm_password = request.form.get('confirm_password')
        
        user = User.query.get(session['user_id'])
        
        if not user or not user.check_password(old_password):
            flash('Current password is incorrect.', 'danger')
            return redirect(url_for('auth.change_password'))
        
        if new_password != confirm_password:
            flash('New passwords do not match.', 'danger')
            return redirect(url_for('auth.change_password'))
        
        if len(new_password) < 8:
            flash('Password must be at least 8 characters.', 'danger')
            return redirect(url_for('auth.change_password'))
        
        user.set_password(new_password)
        db.session.commit()
        flash('Password changed successfully.', 'success')
        return redirect(url_for('auth.login'))
    
    return render_template('auth/change_password.html')
