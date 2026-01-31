"""
Utility Functions - QR Code Generation and Validation
"""

import uuid
import qrcode
import io
import base64
from datetime import datetime

def generate_qr_code(registration_id, event_id, student_id):
    """
    Generate unique QR code for event registration
    Returns: unique QR string and base64 image data
    """
    # Create unique QR code data with UUID
    qr_data = f"REG-{registration_id}-EVT-{event_id}-STU-{student_id}-{uuid.uuid4().hex[:8]}"
    
    # Generate QR code image
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(qr_data)
    qr.make(fit=True)
    
    # Create image
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Convert to base64 for display
    buffered = io.BytesIO()
    img.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    
    return qr_data, img_str


def validate_qr_code(qr_data):
    """
    Validate and extract information from QR code
    Returns: dict with registration_id, event_id, student_id or None if invalid
    """
    try:
        parts = qr_data.split('-')
        if len(parts) >= 7 and parts[0] == 'REG' and parts[2] == 'EVT' and parts[4] == 'STU':
            return {
                'registration_id': int(parts[1]),
                'event_id': int(parts[3]),
                'student_id': int(parts[5])
            }
    except:
        pass
    return None
