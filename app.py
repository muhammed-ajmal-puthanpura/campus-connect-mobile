"""
Campus Event Management System - Main Application
"""

from flask import Flask, render_template, redirect, url_for, session
from datetime import timedelta
import os

# Initialize Flask app
app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = 'secret123'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Root1234%21@127.0.0.1:3306/campus_event_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = os.path.join(os.path.dirname(__file__), 'static/uploads')
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=2)

# Initialize database
from models import db
db.init_app(app)

# Ensure DB has new columns for event mode and meeting_url (non-destructive)
def ensure_event_columns():
    from sqlalchemy import text
    # Check information_schema for columns
    check_mode = text("""
        SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'events' AND COLUMN_NAME = 'mode'
    """)
    check_meeting = text("""
        SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'events' AND COLUMN_NAME = 'meeting_url'
    """)
    check_poster = text("""
        SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'events' AND COLUMN_NAME = 'poster_url'
    """)
    try:
        with app.app_context():
            r1 = db.session.execute(check_mode).scalar()
            r2 = db.session.execute(check_meeting).scalar()
            r3 = db.session.execute(check_poster).scalar()
            if r1 == 0:
                db.session.execute(text("ALTER TABLE events ADD COLUMN mode VARCHAR(20) DEFAULT 'offline';"))
            if r2 == 0:
                db.session.execute(text("ALTER TABLE events ADD COLUMN meeting_url VARCHAR(255) NULL;"))
            if r3 == 0:
                db.session.execute(text("ALTER TABLE events ADD COLUMN poster_url VARCHAR(255) NULL;"))
            # Ensure venue_id column allows NULL for online events
            check_venue_nullable = text("""
                SELECT IS_NULLABLE FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'events' AND COLUMN_NAME = 'venue_id'
            """)
            r4 = db.session.execute(check_venue_nullable).scalar()
            if r4 == 'NO':
                # Update any placeholder 0 values to NULL, then modify column to allow NULL
                try:
                    db.session.execute(text("UPDATE events SET venue_id = NULL WHERE venue_id = 0;"))
                except Exception:
                    # ignore if update fails
                    db.session.rollback()
                db.session.execute(text("ALTER TABLE events MODIFY COLUMN venue_id INT NULL;"))
            db.session.commit()
    except Exception:
        # If DB doesn't exist yet or other error, skip — db.create_all() will create columns for new installs
        db.session.rollback()


# Create upload folders if they don't exist
os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'certificates'), exist_ok=True)
os.makedirs(os.path.join(app.config['UPLOAD_FOLDER'], 'events'), exist_ok=True)

# Import routes (after db initialization)
from routes import auth, student, organizer, hod, principal, admin, common

# Register blueprints
app.register_blueprint(auth.bp)
app.register_blueprint(student.bp)
app.register_blueprint(organizer.bp)
app.register_blueprint(hod.bp)
app.register_blueprint(principal.bp)
app.register_blueprint(admin.bp)
app.register_blueprint(common.bp)

# Home route
@app.route('/')
def index():
    """Landing page - redirect based on login status"""
    if 'user_id' in session:
        role = session.get('role_name')
        if role == 'Student':
            return redirect(url_for('student.dashboard'))
        elif role == 'Event Organizer':
            return redirect(url_for('organizer.dashboard'))
        elif role == 'HOD':
            return redirect(url_for('hod.dashboard'))
        elif role == 'Principal':
            return redirect(url_for('principal.dashboard'))
        elif role == 'Admin':
            return redirect(url_for('admin.dashboard'))
    return redirect(url_for('auth.login'))

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return render_template('500.html'), 500

if __name__ == '__main__':
    with app.app_context():
        # Import models
        from models import models
        
        # Create all tables
        db.create_all()

        # Ensure new event columns exist (mode, meeting_url)
        ensure_event_columns()
        
        # Seed database with demo data
        from utils.seed_data import seed_database
        seed_database()
        
    app.run(debug=True, host='0.0.0.0', port=5000)
