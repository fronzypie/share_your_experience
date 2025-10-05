"""
Authentication Service
Implements authentication business logic with OOP principles:
- Single Responsibility: Handles authentication only
- Encapsulation: Session management is hidden
"""
import secrets
from models import db, User
from utils.validators import Validator


class AuthService:
    """
    Service class for handling authentication operations
    Implements Singleton pattern for session storage
    """
    
    # Class-level session storage (Singleton pattern)
    _active_sessions = {}
    
    @classmethod
    def register_user(cls, username, password):
        """
        Register a new user
        
        Args:
            username (str): Desired username
            password (str): Plain text password
            
        Returns:
            tuple: (user_dict, token, error_message, status_code)
        """
        # Validate input
        is_valid, error_message = Validator.validate_registration(username, password)
        if not is_valid:
            return None, None, error_message, 400
        
        # Check if username exists
        if User.query.filter_by(username=username).first():
            return None, None, 'Username already exists', 409
        
        # Create user
        user = User(username=username)
        user.set_password(password)
        
        try:
            db.session.add(user)
            db.session.commit()
            
            # Create session
            token = cls._create_session(user.id)
            
            return user.to_dict(), token, 'User registered successfully', 201
        except Exception as e:
            db.session.rollback()
            return None, None, f'Database error: {str(e)}', 500
    
    @classmethod
    def login_user(cls, username, password):
        """
        Login an existing user
        
        Args:
            username (str): Username
            password (str): Plain text password
            
        Returns:
            tuple: (user_dict, token, error_message, status_code)
        """
        # Validate input
        if not username or not password:
            return None, None, 'Username and password are required', 400
        
        # Find user
        user = User.query.filter_by(username=username).first()
        
        if not user or not user.check_password(password):
            return None, None, 'Invalid username or password', 401
        
        # Create session
        token = cls._create_session(user.id)
        
        return user.to_dict(), token, 'Login successful', 200
    
    @classmethod
    def logout_user(cls, token):
        """
        Logout a user by invalidating their session
        
        Args:
            token (str): Session token
            
        Returns:
            tuple: (success, message, status_code)
        """
        cls._active_sessions.pop(token, None)
        return True, 'Logout successful', 200
    
    @classmethod
    def get_current_user(cls, token):
        """
        Get current user from session token
        
        Args:
            token (str): Session token
            
        Returns:
            tuple: (user_dict, error_message, status_code)
        """
        user_id = cls._get_user_id_from_token(token)
        
        if not user_id:
            return None, 'Invalid or expired session', 401
        
        user = User.query.get(user_id)
        
        if not user:
            return None, 'User not found', 404
        
        return user.to_dict(), None, 200
    
    @classmethod
    def verify_token(cls, token):
        """
        Verify if a token is valid and return user_id
        
        Args:
            token (str): Session token
            
        Returns:
            int or None: User ID if token is valid, None otherwise
        """
        return cls._get_user_id_from_token(token)
    
    @classmethod
    def _create_session(cls, user_id):
        """
        Create a new session token
        Encapsulation: Private method
        
        Args:
            user_id (int): User ID
            
        Returns:
            str: Session token
        """
        token = secrets.token_hex(32)
        cls._active_sessions[token] = user_id
        return token
    
    @classmethod
    def _get_user_id_from_token(cls, token):
        """
        Get user ID from session token
        Encapsulation: Private method
        
        Args:
            token (str): Session token
            
        Returns:
            int or None: User ID if found
        """
        return cls._active_sessions.get(token)
    
    @classmethod
    def get_active_sessions_count(cls):
        """
        Get number of active sessions (for monitoring)
        
        Returns:
            int: Number of active sessions
        """
        return len(cls._active_sessions)

