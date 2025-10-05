"""
User Model
Implements user entity with OOP principles:
- Encapsulation: Password is hashed and not directly accessible
- Single Responsibility: User management only
"""
from models import db
from werkzeug.security import generate_password_hash, check_password_hash


class User(db.Model):
    """
    User model representing a registered user
    
    Attributes:
        id (int): Primary key
        username (str): Unique username
        password_hash (str): Hashed password
        experiences (list): Related experiences (One-to-Many relationship)
    """
    
    __tablename__ = 'user'
    
    # Columns
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(200), nullable=False)
    
    # Relationships
    experiences = db.relationship(
        'Experience', 
        backref='author', 
        lazy=True, 
        cascade='all, delete-orphan'
    )
    
    def __init__(self, username):
        """
        Initialize a new User
        
        Args:
            username (str): The username for the user
        """
        self.username = username
    
    def set_password(self, password):
        """
        Hash and set the user's password
        Encapsulation: Password is never stored in plain text
        
        Args:
            password (str): Plain text password
        """
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """
        Verify a password against the stored hash
        
        Args:
            password (str): Plain text password to verify
            
        Returns:
            bool: True if password matches, False otherwise
        """
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        """
        Convert user object to dictionary
        Abstraction: Hides implementation details
        
        Returns:
            dict: User data without sensitive information
        """
        return {
            'id': self.id,
            'username': self.username
        }
    
    def __repr__(self):
        """String representation of User"""
        return f'<User {self.username}>'

