"""
Authentication Routes
Implements authentication endpoints with OOP principles:
- Single Responsibility: Only handles auth routes
- Separation of Concerns: Business logic delegated to service layer
"""
from flask import Blueprint, request, jsonify
from services.auth_service import AuthService
from utils.validators import Validator

# Create blueprint
auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')


@auth_bp.route('/register', methods=['POST'])
def register():
    """
    Register a new user
    
    Request Body:
        {
            "username": "string",
            "password": "string"
        }
    
    Returns:
        JSON response with user data and token
    """
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    username = data.get('username')
    password = data.get('password')
    
    # Delegate to service layer
    user_dict, token, message, status_code = AuthService.register_user(username, password)
    
    if status_code == 201:
        return jsonify({
            'message': message,
            'user': user_dict,
            'token': token
        }), status_code
    else:
        return jsonify({'error': message}), status_code


@auth_bp.route('/login', methods=['POST'])
def login():
    """
    Login an existing user
    
    Request Body:
        {
            "username": "string",
            "password": "string"
        }
    
    Returns:
        JSON response with user data and token
    """
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    username = data.get('username')
    password = data.get('password')
    
    # Delegate to service layer
    user_dict, token, message, status_code = AuthService.login_user(username, password)
    
    if status_code == 200:
        return jsonify({
            'message': message,
            'user': user_dict,
            'token': token
        }), status_code
    else:
        return jsonify({'error': message}), status_code


@auth_bp.route('/logout', methods=['POST'])
def logout():
    """
    Logout current user
    
    Headers:
        Authorization: Bearer <token>
    
    Returns:
        JSON response with success message
    """
    token = Validator.extract_token(request)
    
    if not token:
        return jsonify({'message': 'No active session'}), 200
    
    # Delegate to service layer
    success, message, status_code = AuthService.logout_user(token)
    
    return jsonify({'message': message}), status_code


@auth_bp.route('/me', methods=['GET'])
def get_current_user():
    """
    Get current authenticated user
    
    Headers:
        Authorization: Bearer <token>
    
    Returns:
        JSON response with user data
    """
    token = Validator.extract_token(request)
    
    if not token:
        return jsonify({'error': 'Unauthorized'}), 401
    
    # Delegate to service layer
    user_dict, error, status_code = AuthService.get_current_user(token)
    
    if status_code == 200:
        return jsonify({'user': user_dict}), status_code
    else:
        return jsonify({'error': error}), status_code

