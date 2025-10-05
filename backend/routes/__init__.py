"""
Routes package initialization
Exports route blueprints
"""
from routes.auth_routes import auth_bp
from routes.experience_routes import experience_bp
from routes.health_routes import health_bp

__all__ = ['auth_bp', 'experience_bp', 'health_bp']

