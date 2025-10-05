"""
Validation Utilities
Implements validation logic with OOP principles:
- Single Responsibility: Only handles validation
- Static Methods: No instance state needed
"""
from config import Config


class Validator:
    """
    Utility class for data validation
    """
    
    @staticmethod
    def validate_registration(username, password):
        """
        Validate registration data
        
        Args:
            username (str): Username to validate
            password (str): Password to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        if not username or not password:
            return False, 'Username and password are required'
        
        if len(username) < Config.MIN_USERNAME_LENGTH:
            return False, f'Username must be at least {Config.MIN_USERNAME_LENGTH} characters long'
        
        if len(username) > Config.MAX_USERNAME_LENGTH:
            return False, f'Username must be at most {Config.MAX_USERNAME_LENGTH} characters long'
        
        if len(password) < Config.MIN_PASSWORD_LENGTH:
            return False, f'Password must be at least {Config.MIN_PASSWORD_LENGTH} characters long'
        
        # Check for valid username characters (alphanumeric and underscore)
        if not username.replace('_', '').isalnum():
            return False, 'Username can only contain letters, numbers, and underscores'
        
        return True, None
    
    @staticmethod
    def validate_experience_data(data):
        """
        Validate experience creation/update data
        
        Args:
            data (dict): Experience data to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        required_fields = [
            'job_title', 'company_name', 'experience_description',
            'difficulty', 'offer_received', 'application_date', 
            'final_decision_date'
        ]
        
        # Check required fields
        for field in required_fields:
            if field not in data:
                return False, f'Missing required field: {field}'
        
        # Validate difficulty
        if data['difficulty'] not in Config.VALID_DIFFICULTIES:
            return False, f'Difficulty must be one of {Config.VALID_DIFFICULTIES}'
        
        # Validate text lengths
        if len(data['job_title']) < 2:
            return False, 'Job title must be at least 2 characters long'
        
        if len(data['company_name']) < 2:
            return False, 'Company name must be at least 2 characters long'
        
        if len(data['experience_description']) < 10:
            return False, 'Experience description must be at least 10 characters long'
        
        # Validate boolean
        if not isinstance(data['offer_received'], bool):
            return False, 'Offer received must be a boolean'
        
        return True, None
    
    @staticmethod
    def extract_token(request):
        """
        Extract bearer token from request headers
        
        Args:
            request: Flask request object
            
        Returns:
            str or None: Token if found, None otherwise
        """
        auth_header = request.headers.get('Authorization')
        
        if not auth_header:
            return None
        
        if not auth_header.startswith('Bearer '):
            return None
        
        return auth_header[7:]  # Remove 'Bearer ' prefix

