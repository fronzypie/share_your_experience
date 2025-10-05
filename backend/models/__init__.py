"""
Models package initialization
Exports all database models
"""
from flask_sqlalchemy import SQLAlchemy

# Initialize SQLAlchemy
db = SQLAlchemy()

# Import models after db initialization
from models.user import User
from models.experience import Experience

__all__ = ['db', 'User', 'Experience']

