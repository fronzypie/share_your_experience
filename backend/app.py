"""
InterviewHub Backend Application
Refactored with OOP principles and modular architecture

Architecture:
    - Models: Database entities (User, Experience)
    - Services: Business logic layer
    - Routes: API endpoints (Blueprints)
    - Utils: Helper functions and decorators
    - Config: Configuration management

OOP Principles Implemented:
    - Encapsulation: Data and methods bundled in classes
    - Inheritance: Config classes inherit from base
    - Polymorphism: Service methods handle different data types
    - Abstraction: Complex logic hidden behind simple interfaces
    - Single Responsibility: Each module has one purpose
    - Separation of Concerns: Clear layers (Model-Service-Controller)
"""
from flask import Flask
from flask_cors import CORS
from config import config
from models import db
from routes import auth_bp, experience_bp, health_bp


def create_app(config_name='development'):
    """
    Application factory pattern
    Creates and configures the Flask application
    
    Args:
        config_name (str): Configuration to use (development/production/testing)
    
    Returns:
        Flask: Configured Flask application instance
    """
    # Create Flask app
    app = Flask(__name__)
    
    # Load configuration
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)
    
    # Initialize extensions
    initialize_extensions(app)
    
    # Register blueprints
    register_blueprints(app)
    
    # Initialize database
    initialize_database(app)
    
    return app


def initialize_extensions(app):
    """
    Initialize Flask extensions
    
    Args:
        app (Flask): Flask application instance
    """
    # Initialize database
    db.init_app(app)
    
    # Initialize CORS
    CORS(app, resources={r"/api/*": {"origins": app.config['CORS_ORIGINS']}})


def register_blueprints(app):
    """
    Register Flask blueprints
    Implements modular routing architecture
    
    Args:
        app (Flask): Flask application instance
    """
    app.register_blueprint(auth_bp)
    app.register_blueprint(experience_bp)
    app.register_blueprint(health_bp)


def initialize_database(app):
    """
    Initialize database tables
    
    Args:
        app (Flask): Flask application instance
    """
    with app.app_context():
        db.create_all()


# Create application instance
app = create_app()


# Error handlers
@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return {'error': 'Resource not found'}, 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return {'error': 'Internal server error'}, 500


@app.errorhandler(400)
def bad_request(error):
    """Handle 400 errors"""
    return {'error': 'Bad request'}, 400


# Main entry point
if __name__ == '__main__':
    # Use port 8000 to avoid conflicts with macOS services
    # (5000=AirPlay, 5001=Control Center)
    app.run(debug=True, host='0.0.0.0', port=8000)
