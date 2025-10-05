"""
Decorators Module
Implements decorators with OOP principles:
- DRY (Don't Repeat Yourself): Reusable authentication logic
- Separation of Concerns: Authentication separated from business logic
"""
from functools import wraps
from flask import request, jsonify
from utils.validators import Validator


def require_auth(f):
    """
    Decorator to require authentication for a route
    Implements Aspect-Oriented Programming pattern
    
    Usage:
        @app.route('/api/protected')
        @require_auth
        def protected_route(user_id):
            # user_id is automatically injected
            return jsonify({'user_id': user_id})
    
    Args:
        f: Function to decorate
        
    Returns:
        Decorated function
    """
    @wraps(f)
    def decorated_function(*args, **kwargs):
        # Import here to avoid circular import
        from services.auth_service import AuthService
        
        # Extract token
        token = Validator.extract_token(request)
        
        if not token:
            return jsonify({'error': 'Unauthorized - Missing token'}), 401
        
        # Verify token
        user_id = AuthService.verify_token(token)
        
        if not user_id:
            return jsonify({'error': 'Unauthorized - Invalid or expired token'}), 401
        
        # Inject user_id into the function
        return f(user_id=user_id, *args, **kwargs)
    
    return decorated_function

