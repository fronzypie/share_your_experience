"""
Experience Model
Implements interview experience entity with OOP principles:
- Single Responsibility: Manages experience data only
- Encapsulation: Data validation and calculated fields
"""
from models import db
from datetime import datetime


class Experience(db.Model):
    """
    Experience model representing an interview experience
    
    Attributes:
        id (int): Primary key
        job_title (str): Position title
        company_name (str): Company name
        experience_description (str): Detailed description
        difficulty (str): Interview difficulty (Easy/Medium/Hard)
        offer_received (bool): Whether an offer was received
        application_date (date): Application submission date
        final_decision_date (date): Final decision date
        user_id (int): Foreign key to User
        created_at (datetime): Timestamp of creation
    """
    
    __tablename__ = 'experience'
    
    # Columns
    id = db.Column(db.Integer, primary_key=True)
    job_title = db.Column(db.String(200), nullable=False)
    company_name = db.Column(db.String(200), nullable=False, index=True)
    experience_description = db.Column(db.Text, nullable=False)
    difficulty = db.Column(db.String(50), nullable=False, index=True)
    offer_received = db.Column(db.Boolean, nullable=False, default=False)
    application_date = db.Column(db.Date, nullable=False)
    final_decision_date = db.Column(db.Date, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, index=True)
    
    def __init__(self, job_title, company_name, experience_description, 
                 difficulty, offer_received, application_date, 
                 final_decision_date, user_id):
        """
        Initialize a new Experience
        
        Args:
            job_title (str): Job title
            company_name (str): Company name
            experience_description (str): Experience description
            difficulty (str): Difficulty level
            offer_received (bool): Offer status
            application_date (date): Application date
            final_decision_date (date): Decision date
            user_id (int): User ID of the author
        """
        self.job_title = job_title
        self.company_name = company_name
        self.experience_description = experience_description
        self.difficulty = difficulty
        self.offer_received = offer_received
        self.application_date = application_date
        self.final_decision_date = final_decision_date
        self.user_id = user_id
    
    def calculate_timeline_days(self):
        """
        Calculate the number of days between application and final decision
        Calculated Field: Implements business logic within the model
        
        Returns:
            int: Number of days in the application timeline
        """
        delta = self.final_decision_date - self.application_date
        return delta.days
    
    def to_dict(self):
        """
        Convert experience object to dictionary
        Abstraction: Provides a clean interface for data access
        
        Returns:
            dict: Experience data including calculated fields
        """
        return {
            'id': self.id,
            'job_title': self.job_title,
            'company_name': self.company_name,
            'experience_description': self.experience_description,
            'difficulty': self.difficulty,
            'offer_received': self.offer_received,
            'application_date': self.application_date.isoformat(),
            'final_decision_date': self.final_decision_date.isoformat(),
            'application_timeline_days': self.calculate_timeline_days(),
            'user_id': self.user_id,
            'author_username': self.author.username,
            'created_at': self.created_at.isoformat()
        }
    
    def update_from_dict(self, data):
        """
        Update experience fields from dictionary
        Encapsulation: Centralizes update logic
        
        Args:
            data (dict): Dictionary with fields to update
        """
        if 'job_title' in data:
            self.job_title = data['job_title']
        if 'company_name' in data:
            self.company_name = data['company_name']
        if 'experience_description' in data:
            self.experience_description = data['experience_description']
        if 'difficulty' in data:
            self.difficulty = data['difficulty']
        if 'offer_received' in data:
            self.offer_received = data['offer_received']
        if 'application_date' in data:
            self.application_date = data['application_date']
        if 'final_decision_date' in data:
            self.final_decision_date = data['final_decision_date']
    
    def __repr__(self):
        """String representation of Experience"""
        return f'<Experience {self.job_title} at {self.company_name}>'

