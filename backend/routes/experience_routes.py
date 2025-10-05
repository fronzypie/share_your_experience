"""
Experience Routes
Implements experience endpoints with OOP principles:
- Single Responsibility: Only handles experience routes
- Separation of Concerns: Business logic delegated to service layer
"""
from flask import Blueprint, request, jsonify
from services.experience_service import ExperienceService
from utils.decorators import require_auth

# Create blueprint
experience_bp = Blueprint('experience', __name__, url_prefix='/api/experiences')


@experience_bp.route('', methods=['GET'])
def get_experiences():
    """
    Get paginated list of experiences with optional filtering and sorting
    
    Query Parameters:
        page (int): Page number (default: 1)
        per_page (int): Items per page (default: 10)
        difficulty (str): Filter by difficulty (Easy/Medium/Hard)
        offer_received (str): Filter by offer status (true/false)
        search (str): Search term for job title, company, or description
        sort_by (str): Sort order (date_desc/date_asc/difficulty)
    
    Returns:
        JSON response with experiences and pagination info
    """
    # Get query parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    difficulty = request.args.get('difficulty')
    offer_received = request.args.get('offer_received')
    search = request.args.get('search')
    sort_by = request.args.get('sort_by', 'date_desc')
    
    # Delegate to service layer
    result, status_code = ExperienceService.get_experiences(
        page=page,
        per_page=per_page,
        difficulty=difficulty,
        offer_received=offer_received,
        search=search,
        sort_by=sort_by
    )
    
    return jsonify(result), status_code


@experience_bp.route('/<int:experience_id>', methods=['GET'])
def get_experience(experience_id):
    """
    Get a single experience by ID
    
    Path Parameters:
        experience_id (int): Experience ID
    
    Returns:
        JSON response with experience data
    """
    # Delegate to service layer
    result, status_code = ExperienceService.get_experience_by_id(experience_id)
    
    return jsonify(result), status_code


@experience_bp.route('', methods=['POST'])
@require_auth
def create_experience(user_id):
    """
    Create a new experience
    Requires authentication
    
    Headers:
        Authorization: Bearer <token>
    
    Request Body:
        {
            "job_title": "string",
            "company_name": "string",
            "experience_description": "string",
            "difficulty": "Easy|Medium|Hard",
            "offer_received": boolean,
            "application_date": "YYYY-MM-DD",
            "final_decision_date": "YYYY-MM-DD"
        }
    
    Returns:
        JSON response with created experience
    """
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    # Delegate to service layer (user_id injected by decorator)
    result, status_code = ExperienceService.create_experience(user_id, data)
    
    return jsonify(result), status_code


@experience_bp.route('/<int:experience_id>', methods=['PUT'])
@require_auth
def update_experience(user_id, experience_id):
    """
    Update an existing experience
    Requires authentication and ownership
    
    Headers:
        Authorization: Bearer <token>
    
    Path Parameters:
        experience_id (int): Experience ID
    
    Request Body:
        Same as create, all fields optional
    
    Returns:
        JSON response with updated experience
    """
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    # Delegate to service layer (user_id injected by decorator)
    result, status_code = ExperienceService.update_experience(
        experience_id, user_id, data
    )
    
    return jsonify(result), status_code


@experience_bp.route('/<int:experience_id>', methods=['DELETE'])
@require_auth
def delete_experience(user_id, experience_id):
    """
    Delete an experience
    Requires authentication and ownership
    
    Headers:
        Authorization: Bearer <token>
    
    Path Parameters:
        experience_id (int): Experience ID
    
    Returns:
        JSON response with success message
    """
    # Delegate to service layer (user_id injected by decorator)
    result, status_code = ExperienceService.delete_experience(
        experience_id, user_id
    )
    
    return jsonify(result), status_code

