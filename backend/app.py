from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, date
import os
import secrets

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', secrets.token_hex(32))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///share_your_experience.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

CORS(app)
db = SQLAlchemy(app)

# Models
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), nullable=False)
    experiences = db.relationship('Experience', backref='author', lazy=True, cascade='all, delete-orphan')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username
        }


class Experience(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    job_title = db.Column(db.String(200), nullable=False)
    company_name = db.Column(db.String(200), nullable=False)
    experience_description = db.Column(db.Text, nullable=False)
    difficulty = db.Column(db.String(50), nullable=False)  # Easy, Medium, Hard
    offer_received = db.Column(db.Boolean, nullable=False)
    application_date = db.Column(db.Date, nullable=False)
    final_decision_date = db.Column(db.Date, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def calculate_timeline_days(self):
        """Calculated field: days between application and final decision"""
        delta = self.final_decision_date - self.application_date
        return delta.days

    def to_dict(self):
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


# Session storage (in-memory for simplicity - in production use Redis or similar)
active_sessions = {}


# Authentication Routes
@app.route('/api/auth/register', methods=['POST'])
def register():
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'error': 'Username and password are required'}), 400
    
    if len(data.get('password', '')) < 6:
        return jsonify({'error': 'Password must be at least 6 characters long'}), 400
    
    if User.query.filter_by(username=data['username']).first():
        return jsonify({'error': 'Username already exists'}), 409
    
    user = User(username=data['username'])
    user.set_password(data['password'])
    
    db.session.add(user)
    db.session.commit()
    
    # Create session
    session_token = secrets.token_hex(32)
    active_sessions[session_token] = user.id
    
    return jsonify({
        'message': 'User registered successfully',
        'user': user.to_dict(),
        'token': session_token
    }), 201


@app.route('/api/auth/login', methods=['POST'])
def login():
    data = request.get_json()
    
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'error': 'Username and password are required'}), 400
    
    user = User.query.filter_by(username=data['username']).first()
    
    if not user or not user.check_password(data['password']):
        return jsonify({'error': 'Invalid username or password'}), 401
    
    # Create session
    session_token = secrets.token_hex(32)
    active_sessions[session_token] = user.id
    
    return jsonify({
        'message': 'Login successful',
        'user': user.to_dict(),
        'token': session_token
    }), 200


@app.route('/api/auth/logout', methods=['POST'])
def logout():
    token = request.headers.get('Authorization')
    if token and token.startswith('Bearer '):
        token = token[7:]
        active_sessions.pop(token, None)
    
    return jsonify({'message': 'Logout successful'}), 200


@app.route('/api/auth/me', methods=['GET'])
def get_current_user():
    token = request.headers.get('Authorization')
    if not token or not token.startswith('Bearer '):
        return jsonify({'error': 'Unauthorized'}), 401
    
    token = token[7:]
    user_id = active_sessions.get(token)
    
    if not user_id:
        return jsonify({'error': 'Invalid or expired session'}), 401
    
    user = User.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    return jsonify({'user': user.to_dict()}), 200


# Experience Routes
@app.route('/api/experiences', methods=['GET'])
def get_experiences():
    """Get paginated list of experiences with optional filtering, sorting, and search"""
    # Pagination parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    # Filter parameters
    difficulty = request.args.get('difficulty')
    offer_received = request.args.get('offer_received')
    
    # Search parameter
    search = request.args.get('search')
    
    # Sort parameter (default: newest first)
    sort_by = request.args.get('sort_by', 'date_desc')
    
    # Build query
    query = Experience.query
    
    # Apply filters
    if difficulty:
        query = query.filter_by(difficulty=difficulty)
    
    if offer_received is not None:
        offer_bool = offer_received.lower() == 'true'
        query = query.filter_by(offer_received=offer_bool)
    
    # Apply search
    if search:
        search_term = f'%{search}%'
        query = query.filter(
            db.or_(
                Experience.job_title.ilike(search_term),
                Experience.company_name.ilike(search_term),
                Experience.experience_description.ilike(search_term)
            )
        )
    
    # Apply sorting
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
    
    # Paginate
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    
    return jsonify({
        'experiences': [exp.to_dict() for exp in pagination.items],
        'total': pagination.total,
        'page': page,
        'per_page': per_page,
        'pages': pagination.pages,
        'has_next': pagination.has_next,
        'has_prev': pagination.has_prev
    }), 200


@app.route('/api/experiences/<int:experience_id>', methods=['GET'])
def get_experience(experience_id):
    """Get a single experience by ID"""
    experience = Experience.query.get(experience_id)
    
    if not experience:
        return jsonify({'error': 'Experience not found'}), 404
    
    return jsonify({'experience': experience.to_dict()}), 200


@app.route('/api/experiences', methods=['POST'])
def create_experience():
    """Create a new experience"""
    token = request.headers.get('Authorization')
    if not token or not token.startswith('Bearer '):
        return jsonify({'error': 'Unauthorized'}), 401
    
    token = token[7:]
    user_id = active_sessions.get(token)
    
    if not user_id:
        return jsonify({'error': 'Invalid or expired session'}), 401
    
    data = request.get_json()
    
    # Validate required fields
    required_fields = ['job_title', 'company_name', 'experience_description', 
                      'difficulty', 'offer_received', 'application_date', 'final_decision_date']
    
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing required field: {field}'}), 400
    
    # Validate difficulty
    if data['difficulty'] not in ['Easy', 'Medium', 'Hard']:
        return jsonify({'error': 'Difficulty must be Easy, Medium, or Hard'}), 400
    
    # Parse dates
    try:
        application_date = datetime.fromisoformat(data['application_date']).date()
        final_decision_date = datetime.fromisoformat(data['final_decision_date']).date()
    except ValueError:
        return jsonify({'error': 'Invalid date format. Use YYYY-MM-DD'}), 400
    
    # Validate date logic
    if final_decision_date < application_date:
        return jsonify({'error': 'Final decision date cannot be before application date'}), 400
    
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
    
    db.session.add(experience)
    db.session.commit()
    
    return jsonify({
        'message': 'Experience created successfully',
        'experience': experience.to_dict()
    }), 201


@app.route('/api/experiences/<int:experience_id>', methods=['PUT'])
def update_experience(experience_id):
    """Update an existing experience"""
    token = request.headers.get('Authorization')
    if not token or not token.startswith('Bearer '):
        return jsonify({'error': 'Unauthorized'}), 401
    
    token = token[7:]
    user_id = active_sessions.get(token)
    
    if not user_id:
        return jsonify({'error': 'Invalid or expired session'}), 401
    
    experience = Experience.query.get(experience_id)
    
    if not experience:
        return jsonify({'error': 'Experience not found'}), 404
    
    # Check if user owns this experience
    if experience.user_id != user_id:
        return jsonify({'error': 'Forbidden: You can only edit your own experiences'}), 403
    
    data = request.get_json()
    
    # Update fields
    if 'job_title' in data:
        experience.job_title = data['job_title']
    if 'company_name' in data:
        experience.company_name = data['company_name']
    if 'experience_description' in data:
        experience.experience_description = data['experience_description']
    if 'difficulty' in data:
        if data['difficulty'] not in ['Easy', 'Medium', 'Hard']:
            return jsonify({'error': 'Difficulty must be Easy, Medium, or Hard'}), 400
        experience.difficulty = data['difficulty']
    if 'offer_received' in data:
        experience.offer_received = data['offer_received']
    if 'application_date' in data:
        try:
            experience.application_date = datetime.fromisoformat(data['application_date']).date()
        except ValueError:
            return jsonify({'error': 'Invalid application_date format'}), 400
    if 'final_decision_date' in data:
        try:
            experience.final_decision_date = datetime.fromisoformat(data['final_decision_date']).date()
        except ValueError:
            return jsonify({'error': 'Invalid final_decision_date format'}), 400
    
    # Validate date logic
    if experience.final_decision_date < experience.application_date:
        return jsonify({'error': 'Final decision date cannot be before application date'}), 400
    
    db.session.commit()
    
    return jsonify({
        'message': 'Experience updated successfully',
        'experience': experience.to_dict()
    }), 200


@app.route('/api/experiences/<int:experience_id>', methods=['DELETE'])
def delete_experience(experience_id):
    """Delete an experience"""
    token = request.headers.get('Authorization')
    if not token or not token.startswith('Bearer '):
        return jsonify({'error': 'Unauthorized'}), 401
    
    token = token[7:]
    user_id = active_sessions.get(token)
    
    if not user_id:
        return jsonify({'error': 'Invalid or expired session'}), 401
    
    experience = Experience.query.get(experience_id)
    
    if not experience:
        return jsonify({'error': 'Experience not found'}), 404
    
    # Check if user owns this experience
    if experience.user_id != user_id:
        return jsonify({'error': 'Forbidden: You can only delete your own experiences'}), 403
    
    db.session.delete(experience)
    db.session.commit()
    
    return jsonify({'message': 'Experience deleted successfully'}), 200


# Health check
@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'}), 200


# Initialize database
with app.app_context():
    db.create_all()


if __name__ == '__main__':
    # Use port 8000 to avoid conflicts with macOS services (5000=AirPlay, 5001=Control Center)
    app.run(debug=True, host='0.0.0.0', port=8000)

