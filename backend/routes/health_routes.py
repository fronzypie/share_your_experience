"""
Health Check Routes
Implements health check endpoint for monitoring
"""
from flask import Blueprint, jsonify

# Create blueprint
health_bp = Blueprint('health', __name__, url_prefix='/api')


@health_bp.route('/health', methods=['GET'])
def health_check():
    """
    Health check endpoint
    
    Returns:
        JSON response with status
    """
    return jsonify({'status': 'healthy'}), 200

