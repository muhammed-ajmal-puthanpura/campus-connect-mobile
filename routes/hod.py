"""
HOD Routes - Approve/Reject Events for Department
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models.models import Event, Approval, User, Venue
from models import db
from datetime import datetime
from functools import wraps
from utils.venue_utils import check_venue_clash, get_clash_message

bp = Blueprint('hod', __name__, url_prefix='/hod')

def hod_required(f):
    """Decorator to require HOD login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session or session.get('role_name', '').lower() != 'hod':
            flash('Access denied', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated_function


@bp.route('/dashboard')
@hod_required
def dashboard():
    """HOD dashboard - view pending approvals"""
    hod_id = session['user_id']
    
    # Get pending approvals for this HOD
    pending_approvals = Approval.query.filter_by(
        approver_id=hod_id,
        status='pending'
    ).all()
    
    # Get all approvals (history)
    all_approvals = Approval.query.filter_by(
        approver_id=hod_id
    ).order_by(Approval.approved_at.desc()).all()
    
    return render_template('hod/dashboard.html',
                         pending_approvals=pending_approvals,
                         all_approvals=all_approvals)


@bp.route('/approve-event/<int:approval_id>', methods=['GET', 'POST'])
@hod_required
def approve_event(approval_id):
    """Approve or reject event"""
    hod_id = session['user_id']
    
    approval = Approval.query.filter_by(
        approval_id=approval_id,
        approver_id=hod_id,
        status='pending'
    ).first_or_404()
    
    event = approval.event
    
    if request.method == 'POST':
        action = request.form.get('action')
        remarks = request.form.get('remarks')
        
        if action == 'approve':
            # Check for venue clash before approving
            clash_info = check_venue_clash(
                event.venue_id,
                event.date,
                event.start_time,
                event.end_time,
                event.event_id
            )
            
            if clash_info['clash']:
                flash(get_clash_message(clash_info['conflicting_events']), 'error')
                return redirect(url_for('hod.approve_event', approval_id=approval_id))
            
            # Approve this stage
            approval.status = 'approved'
            approval.remarks = remarks
            approval.approved_at = datetime.now()
            
            # Check if all required approvals are complete
            all_approvals = Approval.query.filter_by(event_id=event.event_id).all()
            
            # If this is the only approval needed (no Principal approval after)
            # or if Principal has also approved, mark event as approved
            # Find principal approval in a case-insensitive way
            principal_approval = next(
                (a for a in all_approvals if (a.approver_role or '').strip().lower() == 'principal'),
                None
            )

            if not principal_approval or principal_approval.status == 'approved':
                event.status = 'approved'
            
            db.session.commit()
            flash('Event approved successfully!', 'success')
            
        elif action == 'reject':
            approval.status = 'rejected'
            approval.remarks = remarks
            approval.approved_at = datetime.now()
            
            # Reject the entire event
            event.status = 'rejected'
            
            # Reject all other pending approvals for this event
            other_approvals = Approval.query.filter_by(
                event_id=event.event_id,
                status='pending'
            ).all()
            
            for other in other_approvals:
                other.status = 'rejected'
                other.remarks = 'Rejected at HOD level'
                other.approved_at = datetime.now()
            
            db.session.commit()
            flash('Event rejected', 'info')
        
        return redirect(url_for('hod.dashboard'))
    
    return render_template('hod/approve_event.html',
                         approval=approval,
                         event=event)
