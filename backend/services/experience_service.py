"""
Experience Service
Implements experience business logic with OOP principles:
- Single Responsibility: Handles experience CRUD operations
- Encapsulation: Query building logic is internal
"""
from datetime import datetime
from models import db, Experience
from utils.validators import Validator
from config import Config


class ExperienceService:
    """
    Service class for handling experience operations
    """
    
    @staticmethod
    def get_experiences(page=1, per_page=None, difficulty=None, 
                       offer_received=None, search=None, sort_by='date_desc'):
        """
        Get paginated list of experiences with filters
        
        Args:
            page (int): Page number
            per_page (int): Items per page
            difficulty (str): Filter by difficulty
            offer_received (str): Filter by offer status
            search (str): Search term
            sort_by (str): Sort order
            
        Returns:
            tuple: (result_dict, status_code)
        """
        if per_page is None:
            per_page = Config.DEFAULT_PAGE_SIZE
        
        # Validate pagination
        if page < 1:
            return {'error': 'Page must be >= 1'}, 400
        if per_page > Config.MAX_PAGE_SIZE:
            return {'error': f'Per page must be <= {Config.MAX_PAGE_SIZE}'}, 400
        
        # Build query
        query = Experience.query
        
        # Apply filters
        query = ExperienceService._apply_filters(
            query, difficulty, offer_received, search
        )
        
        # Apply sorting
        query = ExperienceService._apply_sorting(query, sort_by)
        
        # Paginate
        try:
            pagination = query.paginate(page=page, per_page=per_page, error_out=False)
            
            return {
                'experiences': [exp.to_dict() for exp in pagination.items],
                'total': pagination.total,
                'page': page,
                'per_page': per_page,
                'pages': pagination.pages,
                'has_next': pagination.has_next,
                'has_prev': pagination.has_prev
            }, 200
        except Exception as e:
            return {'error': f'Database error: {str(e)}'}, 500
    
    @staticmethod
    def get_experience_by_id(experience_id):
        """
        Get a single experience by ID
        
        Args:
            experience_id (int): Experience ID
            
        Returns:
            tuple: (experience_dict or error, status_code)
        """
        experience = Experience.query.get(experience_id)
        
        if not experience:
            return {'error': 'Experience not found'}, 404
        
        return {'experience': experience.to_dict()}, 200
    
    @staticmethod
    def create_experience(user_id, data):
        """
        Create a new experience
        
        Args:
            user_id (int): ID of the user creating the experience
            data (dict): Experience data
            
        Returns:
            tuple: (result_dict, status_code)
        """
        # Validate data
        is_valid, errors = Validator.validate_experience_data(data)
        if not is_valid:
            return {'error': errors}, 400
        
        # Parse dates
        try:
            application_date = datetime.fromisoformat(data['application_date']).date()
            final_decision_date = datetime.fromisoformat(data['final_decision_date']).date()
        except ValueError:
            return {'error': 'Invalid date format. Use YYYY-MM-DD'}, 400
        
        # Validate date logic
        if final_decision_date < application_date:
            return {'error': 'Final decision date cannot be before application date'}, 400
        
        # Create experience
        experience = Experience(
            job_title=data['job_title'],
            company_name=data['company_name'],
            experience_description=data['experience_description'],
            difficulty=data['difficulty'],
            offer_received=data['offer_received'],
            application_date=application_date,
            final_decision_date=final_decision_date,
            user_id=user_id
        )
        
        try:
            db.session.add(experience)
            db.session.commit()
            
            return {
                'message': 'Experience created successfully',
                'experience': experience.to_dict()
            }, 201
        except Exception as e:
            db.session.rollback()
            return {'error': f'Database error: {str(e)}'}, 500
    
    @staticmethod
    def update_experience(experience_id, user_id, data):
        """
        Update an existing experience
        
        Args:
            experience_id (int): Experience ID
            user_id (int): ID of the user making the update
            data (dict): Updated data
            
        Returns:
            tuple: (result_dict, status_code)
        """
        experience = Experience.query.get(experience_id)
        
        if not experience:
            return {'error': 'Experience not found'}, 404
        
        # Check ownership
        if experience.user_id != user_id:
            return {'error': 'Forbidden: You can only edit your own experiences'}, 403
        
        # Validate difficulty if present
        if 'difficulty' in data:
            if data['difficulty'] not in Config.VALID_DIFFICULTIES:
                return {'error': f'Difficulty must be one of {Config.VALID_DIFFICULTIES}'}, 400
        
        # Parse dates if present
        try:
            if 'application_date' in data:
                data['application_date'] = datetime.fromisoformat(data['application_date']).date()
            if 'final_decision_date' in data:
                data['final_decision_date'] = datetime.fromisoformat(data['final_decision_date']).date()
        except ValueError:
            return {'error': 'Invalid date format. Use YYYY-MM-DD'}, 400
        
        # Update experience
        experience.update_from_dict(data)
        
        # Validate date logic
        if experience.final_decision_date < experience.application_date:
            return {'error': 'Final decision date cannot be before application date'}, 400
        
        try:
            db.session.commit()
            
            return {
                'message': 'Experience updated successfully',
                'experience': experience.to_dict()
            }, 200
        except Exception as e:
            db.session.rollback()
            return {'error': f'Database error: {str(e)}'}, 500
    
    @staticmethod
    def delete_experience(experience_id, user_id):
        """
        Delete an experience
        
        Args:
            experience_id (int): Experience ID
            user_id (int): ID of the user making the deletion
            
        Returns:
            tuple: (result_dict, status_code)
        """
        experience = Experience.query.get(experience_id)
        
        if not experience:
            return {'error': 'Experience not found'}, 404
        
        # Check ownership
        if experience.user_id != user_id:
            return {'error': 'Forbidden: You can only delete your own experiences'}, 403
        
        try:
            db.session.delete(experience)
            db.session.commit()
            
            return {'message': 'Experience deleted successfully'}, 200
        except Exception as e:
            db.session.rollback()
            return {'error': f'Database error: {str(e)}'}, 500
    
    @staticmethod
    def _apply_filters(query, difficulty, offer_received, search):
        """
        Apply filters to query
        Encapsulation: Private method
        
        Args:
            query: SQLAlchemy query object
            difficulty (str): Difficulty filter
            offer_received (str): Offer filter
            search (str): Search term
            
        Returns:
            SQLAlchemy query object
        """
        if difficulty:
            query = query.filter_by(difficulty=difficulty)
        
        if offer_received is not None:
            offer_bool = offer_received.lower() == 'true'
            query = query.filter_by(offer_received=offer_bool)
        
        if search:
            search_term = f'%{search}%'
            query = query.filter(
                db.or_(
                    Experience.job_title.ilike(search_term),
                    Experience.company_name.ilike(search_term),
                    Experience.experience_description.ilike(search_term)
                )
            )
        
        return query
    
    @staticmethod
    def _apply_sorting(query, sort_by):
        """
        Apply sorting to query
        Encapsulation: Private method
        
        Args:
            query: SQLAlchemy query object
            sort_by (str): Sort order
            
        Returns:
            SQLAlchemy query object
        """
        if sort_by == 'date_desc':
            query = query.order_by(Experience.created_at.desc())
        elif sort_by == 'date_asc':
            query = query.order_by(Experience.created_at.asc())
        elif sort_by == 'difficulty':
            # Custom order: Easy, Medium, Hard
            query = query.order_by(
                db.case(
                    (Experience.difficulty == 'Easy', 1),
                    (Experience.difficulty == 'Medium', 2),
                    (Experience.difficulty == 'Hard', 3),
                    else_=4
                )
            )
        else:
            # Default: newest first
            query = query.order_by(Experience.created_at.desc())
        
        return query

