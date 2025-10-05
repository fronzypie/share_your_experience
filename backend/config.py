"""
Configuration module for the application
Implements configuration as a class (OOP principle: Encapsulation)
"""
import os
import secrets


class Config:
    """Base configuration class"""
    
    # Flask Configuration
    SECRET_KEY = os.environ.get('SECRET_KEY', secrets.token_hex(32))
    
    # Database Configuration
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'sqlite:///share_your_experience.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # CORS Configuration
    CORS_ORIGINS = os.environ.get('CORS_ORIGINS', '*')
    
    # Pagination Configuration
    DEFAULT_PAGE_SIZE = 10
    MAX_PAGE_SIZE = 100
    
    # Validation Configuration
    MIN_PASSWORD_LENGTH = 6
    MIN_USERNAME_LENGTH = 3
    MAX_USERNAME_LENGTH = 80
    
    # Difficulty Levels
    VALID_DIFFICULTIES = ['Easy', 'Medium', 'Hard']
    
    @classmethod
    def init_app(cls, app):
        """Initialize application with configuration"""
        app.config.from_object(cls)


class DevelopmentConfig(Config):
    """Development configuration"""
    DEBUG = True
    TESTING = False


class ProductionConfig(Config):
    """Production configuration"""
    DEBUG = False
    TESTING = False


class TestingConfig(Config):
    """Testing configuration"""
    DEBUG = True
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///:memory:'


# Configuration dictionary
config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}

