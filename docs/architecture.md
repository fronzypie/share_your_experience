# Architecture Documentation

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────┐
│                     User Browser                         │
│                   (Flutter Web App)                      │
└──────────────────────┬──────────────────────────────────┘
                       │
                       │ HTTP/REST API
                       │
┌──────────────────────▼──────────────────────────────────┐
│                  Flask Backend                           │
│              (Python Web Server)                         │
│                                                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │           Route Handlers                         │   │
│  │  • /api/auth/*  (Authentication)                │   │
│  │  • /api/experiences/*  (CRUD Operations)        │   │
│  └─────────────────────────────────────────────────┘   │
│                       │                                  │
│  ┌─────────────────────────────────────────────────┐   │
│  │           SQLAlchemy ORM                         │   │
│  │  • User Model                                    │   │
│  │  • Experience Model                              │   │
│  └─────────────────────────────────────────────────┘   │
└──────────────────────┬──────────────────────────────────┘
                       │
                       │
┌──────────────────────▼──────────────────────────────────┐
│                SQLite Database                           │
│           (share_your_experience.db)                     │
│                                                           │
│  Tables:                                                 │
│  • users                                                 │
│  • experiences                                           │
└─────────────────────────────────────────────────────────┘
```

## Frontend Architecture (Flutter Web)

### Directory Structure
```
frontend/lib/
├── main.dart                 # Entry point & app configuration
├── models/                   # Data models
│   ├── user.dart
│   └── experience.dart
├── services/                 # Business logic & API calls
│   ├── api_service.dart      # HTTP client wrapper
│   └── auth_service.dart     # Authentication state management
├── screens/                  # UI screens (pages)
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── main_feed_screen.dart
│   ├── experience_detail_screen.dart
│   └── create_edit_experience_screen.dart
└── widgets/                  # Reusable UI components
    └── experience_card.dart
```

### State Management
- **Provider Pattern**: Used for dependency injection and state management
- **Services**: `AuthService` notifies listeners when auth state changes
- **Local Storage**: `SharedPreferences` for persisting auth tokens

### Data Flow

```
User Action → Screen → Service → API Service → Backend
                 ↑                                 │
                 └─────────── Response ────────────┘
```

## Backend Architecture (Flask)

### File Structure
```
backend/
├── app.py                    # Main application file
│   ├── Models (User, Experience)
│   ├── Routes (Auth, CRUD)
│   └── Database initialization
└── requirements.txt          # Python dependencies
```

### Database Models

#### User Model
```python
class User:
    - id: Integer (PK)
    - username: String (Unique)
    - password_hash: String
    - experiences: Relationship → Experience[]
    
    Methods:
    - set_password(password)
    - check_password(password)
    - to_dict()
```

#### Experience Model
```python
class Experience:
    - id: Integer (PK)
    - job_title: String
    - company_name: String
    - experience_description: Text
    - difficulty: String (Enum)
    - offer_received: Boolean
    - application_date: Date
    - final_decision_date: Date
    - user_id: Integer (FK → User)
    - created_at: DateTime
    
    Methods:
    - calculate_timeline_days()  # Calculated field
    - to_dict()
```

### API Endpoints

#### Authentication Endpoints
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| POST | `/api/auth/logout` | Logout user | Yes |
| GET | `/api/auth/me` | Get current user | Yes |

#### Experience Endpoints
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/experiences` | List all experiences | No |
| GET | `/api/experiences/:id` | Get single experience | No |
| POST | `/api/experiences` | Create experience | Yes |
| PUT | `/api/experiences/:id` | Update experience | Yes (Owner) |
| DELETE | `/api/experiences/:id` | Delete experience | Yes (Owner) |

#### Query Parameters for GET /api/experiences
- `page`: Page number (default: 1)
- `per_page`: Items per page (default: 10)
- `difficulty`: Filter by difficulty (Easy/Medium/Hard)
- `search`: Search term
- `sort_by`: Sort order (date_desc, date_asc, difficulty)

### Authentication Flow

```
┌────────────┐                ┌────────────┐
│   Client   │                │   Server   │
└──────┬─────┘                └──────┬─────┘
       │                             │
       │ POST /api/auth/register     │
       ├────────────────────────────►│
       │   {username, password}      │
       │                             │
       │◄────────────────────────────┤
       │   {user, token}             │
       │                             │
       │ Subsequent requests         │
       ├────────────────────────────►│
       │ Header: Authorization:      │
       │         Bearer <token>      │
       │                             │
```

### Session Management
- **Token Generation**: Using Python's `secrets` module
- **Storage**: In-memory dictionary (for development)
- **Production Note**: Should use Redis or similar for production

## Database Schema

### Entity Relationship Diagram

```
┌─────────────────────┐
│       User          │
├─────────────────────┤
│ id (PK)             │
│ username (UNIQUE)   │
│ password_hash       │
└──────────┬──────────┘
           │
           │ 1:N
           │
┌──────────▼──────────┐
│    Experience       │
├─────────────────────┤
│ id (PK)             │
│ job_title           │
│ company_name        │
│ experience_desc     │
│ difficulty          │
│ offer_received      │
│ application_date    │
│ final_decision_date │
│ user_id (FK)        │
│ created_at          │
└─────────────────────┘
```

## Data Validation

### Frontend Validation
- Username: Required
- Password: Required, minimum 6 characters
- Confirm Password: Must match password
- Job Title: Required
- Company Name: Required
- Description: Required
- Dates: Required, final_date >= application_date

### Backend Validation
- Duplicate username check
- Password strength validation
- Date logic validation
- Difficulty enum validation
- Required field checks

## Security Features

1. **Password Hashing**: Werkzeug's `generate_password_hash` with SHA-256
2. **Session Tokens**: 64-character hexadecimal tokens
3. **Authorization**: Bearer token authentication
4. **Ownership Checks**: Users can only edit/delete their own posts
5. **CORS**: Configured for cross-origin requests

## Performance Considerations

### Pagination
- Default 10 items per page
- Reduces database load
- Improves frontend rendering

### Database Indexes
- Primary keys auto-indexed
- Username unique constraint creates index
- Foreign key relationships indexed

### Frontend Optimization
- Stateful widgets only where needed
- Efficient re-rendering with Provider
- Form validation on client side
- Optimistic UI updates

## Deployment Architecture

### Recommended Setup

```
┌─────────────────────────────────────────────┐
│         CDN / Static Hosting                │
│      (Vercel, Netlify, Firebase)            │
│          Flutter Web Build                  │
└──────────────────┬──────────────────────────┘
                   │
                   │ API Calls
                   │
┌──────────────────▼──────────────────────────┐
│         Application Server                   │
│      (Render, Heroku, AWS EC2)              │
│            Flask Backend                     │
└──────────────────┬──────────────────────────┘
                   │
                   │
┌──────────────────▼──────────────────────────┐
│         Database                             │
│      (SQLite file or PostgreSQL)            │
└─────────────────────────────────────────────┘
```

### Environment Variables
- `SECRET_KEY`: For session management
- `DATABASE_URL`: Database connection string (if not SQLite)
- `FLASK_ENV`: production/development

## Scalability Considerations

### Current Architecture (MVP)
- In-memory session storage
- SQLite database
- Single server deployment

### Production Recommendations
1. **Session Storage**: Migrate to Redis
2. **Database**: Upgrade to PostgreSQL or MySQL
3. **Caching**: Add Redis for frequently accessed data
4. **Load Balancing**: Add nginx or cloud load balancer
5. **Static Assets**: Serve through CDN
6. **Monitoring**: Add logging and error tracking (Sentry)

## Testing Strategy

### Backend Testing
- Unit tests for models
- Integration tests for API endpoints
- Authentication flow tests
- CRUD operation tests

### Frontend Testing
- Widget tests for UI components
- Integration tests for user flows
- End-to-end tests with Flutter Driver

### Manual Testing Checklist
- [ ] User registration
- [ ] User login
- [ ] Create experience
- [ ] View experience list
- [ ] Search experiences
- [ ] Filter by difficulty
- [ ] Sort experiences
- [ ] Pagination
- [ ] Edit own experience
- [ ] Delete own experience
- [ ] View experience details
- [ ] Logout

## Code Quality Metrics

### Backend
- **Lines of Code**: ~400
- **Functions**: 15 endpoints
- **Models**: 2 classes
- **Test Coverage**: N/A (MVP)

### Frontend
- **Lines of Code**: ~1500
- **Screens**: 5 main screens
- **Widgets**: 1 reusable widget
- **Services**: 2 service classes
- **Models**: 2 data models

## OOP Principles Demonstrated

### Encapsulation
- Models encapsulate data and behavior
- Services hide implementation details

### Abstraction
- API Service abstracts HTTP calls
- Auth Service abstracts authentication logic

### Modularity
- Clear separation of concerns
- Each file has single responsibility

### Inheritance
- StatefulWidget/StatelessWidget inheritance
- db.Model inheritance for SQLAlchemy

## Future Enhancements

1. **Features**
   - User profiles with avatars
   - Comments on experiences
   - Upvote/downvote system
   - Email notifications
   - Advanced filters (date range, location)

2. **Technical**
   - Real-time updates with WebSockets
   - File upload for resume/documents
   - Export experiences to PDF
   - OAuth integration (Google, LinkedIn)
   - Progressive Web App (PWA) features

3. **Analytics**
   - View counts
   - Popular companies
   - Average interview difficulty by company
   - Success rate statistics

## Conclusion

This architecture provides a solid foundation for a production-ready interview experience sharing platform. The modular design allows for easy maintenance and future enhancements while following industry best practices and OOP principles.

