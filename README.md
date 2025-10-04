# Share Your Experience - Interview Hub

A full-stack web application for sharing and discovering interview experiences. Built with Flutter Web for the frontend and Flask (Python) for the backend.

## 🎯 Project Overview

**InterviewHub** is a platform where users can:
- Share their interview experiences with job title, company, difficulty rating, and detailed descriptions
- Browse and search through community-shared experiences
- Filter by difficulty and sort by various criteria
- Track application timelines with automatic calculation of days
- Manage their own posts with edit and delete functionality

## 🏗️ Architecture

### Frontend
- **Framework**: Flutter Web
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences

### Backend
- **Framework**: Flask (Python)
- **Database**: SQLite with SQLAlchemy ORM
- **Authentication**: Session-based with secure password hashing (Werkzeug)
- **CORS**: Flask-CORS for cross-origin requests

## ✨ Features

### Authentication System
- ✅ User registration with username/password
- ✅ Secure login with password hashing
- ✅ Session management with bearer tokens
- ✅ Persistent authentication across sessions

### CRUD Operations
- ✅ **Create**: Share new interview experiences
- ✅ **Read**: View all experiences or detailed single experience
- ✅ **Update**: Edit your own experiences
- ✅ **Delete**: Remove your own experiences

### Required Fields
- ✅ **Text Fields**: Job Title, Company Name, Description
- ✅ **Enum Field**: Difficulty (Easy, Medium, Hard)
- ✅ **Boolean Field**: Offer Received (Yes/No)
- ✅ **Calculated Field**: Application Timeline Days (derived from Application Date and Final Decision Date)

### Listing & Data Management
- ✅ **Pagination**: 10 items per page with next/previous controls
- ✅ **Filtering**: Filter experiences by difficulty level
- ✅ **Sorting**: Sort by newest, oldest, or difficulty
- ✅ **Search**: Full-text search across job titles, companies, and descriptions

### UI/UX
- ✅ Modern, clean Material Design interface
- ✅ Responsive layout that works on all screen sizes
- ✅ Color-coded difficulty badges
- ✅ Card-based layouts for easy scanning
- ✅ Form validation with helpful error messages

## 📁 Project Structure

```
share_your_experience/
├── backend/
│   ├── app.py                 # Flask application with all routes and models
│   ├── requirements.txt        # Python dependencies
│   └── share_your_experience.db  # SQLite database (created on first run)
│
├── frontend/
│   ├── lib/
│   │   ├── main.dart          # App entry point and configuration
│   │   ├── models/
│   │   │   ├── user.dart      # User model
│   │   │   └── experience.dart # Experience model
│   │   ├── services/
│   │   │   ├── api_service.dart   # HTTP API client
│   │   │   └── auth_service.dart  # Authentication service
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── registration_screen.dart
│   │   │   ├── main_feed_screen.dart
│   │   │   ├── experience_detail_screen.dart
│   │   │   └── create_edit_experience_screen.dart
│   │   └── widgets/
│   │       └── experience_card.dart
│   ├── web/
│   │   ├── index.html
│   │   └── manifest.json
│   ├── pubspec.yaml           # Flutter dependencies
│   └── analysis_options.yaml
│
└── README.md                  # This file
```

## 🚀 Setup Instructions

### Prerequisites
- Python 3.8 or higher
- Flutter SDK 3.0 or higher
- A modern web browser (Chrome recommended)

### Backend Setup

1. **Navigate to the backend directory:**
   ```bash
   cd share_your_experience/backend
   ```

2. **Create and activate a virtual environment:**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the Flask server:**
   ```bash
   python app.py
   ```
   The backend will start on `http://localhost:5000`

### Frontend Setup

1. **Open a new terminal and navigate to the frontend directory:**
   ```bash
   cd share_your_experience/frontend
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Flutter web app:**
   ```bash
   flutter run -d chrome
   ```
   Or build for production:
   ```bash
   flutter build web
   ```

4. **Access the application:**
   Open your browser to `http://localhost:<port>` (Flutter will show you the port)

## 🔧 Configuration

### Changing the Backend URL

If you deploy the backend to a different host, update the API base URL in `frontend/lib/main.dart`:

```dart
Provider<ApiService>(
  create: (_) => ApiService(baseUrl: 'https://your-backend-url.com'),
),
```

### Environment Variables

The backend supports the following environment variables:
- `SECRET_KEY`: Secret key for session management (auto-generated if not provided)

## 📊 Database Schema

### User Table
- `id`: Integer (Primary Key)
- `username`: String (Unique)
- `password_hash`: String

### Experience Table
- `id`: Integer (Primary Key)
- `job_title`: String
- `company_name`: String
- `experience_description`: Text
- `difficulty`: String (Easy/Medium/Hard)
- `offer_received`: Boolean
- `application_date`: Date
- `final_decision_date`: Date
- `user_id`: Integer (Foreign Key → User)
- `created_at`: DateTime

**Calculated Field:**
- `application_timeline_days`: Computed as `final_decision_date - application_date`

## 🌐 API Documentation

### Quick Reference

**Authentication**
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login and receive a token
- `POST /api/auth/logout` - Logout
- `GET /api/auth/me` - Get current user info

**Experiences**
- `GET /api/experiences` - Get paginated list (supports filters, search, sort)
- `GET /api/experiences/:id` - Get single experience
- `POST /api/experiences` - Create new experience (requires auth)
- `PUT /api/experiences/:id` - Update experience (requires auth & ownership)
- `DELETE /api/experiences/:id` - Delete experience (requires auth & ownership)

### 📖 Complete API Documentation

For detailed API documentation with request/response examples, validation rules, and error codes:

**📄 [View Full API Documentation](docs/API_DOCUMENTATION.md)**

**🚀 [API Quick Start Guide](docs/API_QUICKSTART.md)**

**📦 [Import Postman Collection](docs/InterviewHub_API.postman_collection.json)**

The API documentation includes:
- Complete endpoint reference with examples
- Request/response formats
- Authentication flow
- Error handling
- cURL, Python, and JavaScript examples
- Postman collection for easy testing

## 🚢 Deployment

### Deploying to Render

#### Backend Deployment

1. **Create a new Web Service on Render**
2. **Connect your repository**
3. **Configure the service:**
   - **Build Command**: `pip install -r backend/requirements.txt`
   - **Start Command**: `cd backend && python app.py`
   - **Environment Variables**: Add `SECRET_KEY` with a secure random value

#### Frontend Deployment

1. **Build the Flutter web app:**
   ```bash
   cd frontend
   flutter build web
   ```

2. **Deploy the `build/web` directory to Render as a Static Site**
   Or use any static hosting service (Vercel, Netlify, GitHub Pages, etc.)

3. **Update the API base URL** in your built frontend to point to your deployed backend

### Alternative Deployment Options

- **Backend**: Heroku, AWS EC2, Google Cloud Run, DigitalOcean
- **Frontend**: Vercel, Netlify, GitHub Pages, Firebase Hosting

## 🧪 Testing the Application

### Manual Testing Checklist

1. **Authentication:**
   - [ ] Register a new account
   - [ ] Login with credentials
   - [ ] Session persists on page refresh
   - [ ] Logout works correctly

2. **CRUD Operations:**
   - [ ] Create a new experience
   - [ ] View experience in the feed
   - [ ] Click to see detailed view
   - [ ] Edit your own experience
   - [ ] Delete your own experience

3. **Data Management:**
   - [ ] Pagination works (next/previous)
   - [ ] Filter by difficulty
   - [ ] Sort by date and difficulty
   - [ ] Search for experiences

4. **Validation:**
   - [ ] Form validation on registration
   - [ ] Form validation on experience creation
   - [ ] Date validation (final date > application date)
   - [ ] Calculated timeline displays correctly

## 📝 AI Integration Documentation

This project was built using **Gemini CLI** (as specified in the assignment requirements). Here are 6+ documented AI prompts and their results:

### AI Prompt Log

1. **Prompt**: "Create a Flask backend with User and Experience models using SQLAlchemy, including authentication endpoints"
   - **Result**: Generated complete `app.py` with models, authentication routes, and session management

2. **Prompt**: "Implement pagination, filtering, sorting, and search for the experiences endpoint"
   - **Result**: Added query parameter handling and SQLAlchemy filtering logic in `GET /api/experiences`

3. **Prompt**: "Create a Flutter service class for making HTTP requests to the Flask API"
   - **Result**: Generated `api_service.dart` with all CRUD methods and proper error handling

4. **Prompt**: "Build a Flutter login screen with form validation and error messages"
   - **Result**: Created `login_screen.dart` with Material Design, validation, and state management

5. **Prompt**: "Create a main feed screen with search bar, filters, sort dropdown, and pagination controls"
   - **Result**: Generated `main_feed_screen.dart` with all interactive elements properly wired

6. **Prompt**: "Design an experience detail screen showing all fields including the calculated timeline"
   - **Result**: Built `experience_detail_screen.dart` with beautiful card layouts and info sections

7. **Prompt**: "Implement a create/edit experience form with date pickers and real-time timeline calculation"
   - **Result**: Created `create_edit_experience_screen.dart` with form validation and date selection

## 🎨 Code Quality

### OOP Concepts Applied
- **Encapsulation**: Models encapsulate data and behavior (e.g., `Experience.calculate_timeline_days()`)
- **Abstraction**: Service classes abstract away HTTP details
- **Modularity**: Clear separation of concerns (models, services, screens, widgets)
- **Clean Code**: Consistent naming, proper structure, comprehensive comments

### Best Practices
- ✅ RESTful API design
- ✅ Secure password hashing
- ✅ Input validation on both frontend and backend
- ✅ Error handling and user feedback
- ✅ Responsive UI design
- ✅ Code organization and modularity

## 📸 Screenshots & Demo

### Development History

All development commits are available in the Git log, showing hourly progress:
- Initial project setup
- Backend implementation
- Frontend screens
- Integration and testing
- Final polish

To view commit history:
```bash
git log --oneline --graph
```

## 👨‍💻 Development Notes

### Code Evolution
Initial commits show the iterative process:
1. Basic authentication system
2. CRUD operations implementation
3. UI/UX enhancements
4. Search and filter features
5. Final integration and bug fixes

### Architectural Decisions

1. **SQLite Database**: Chosen for simplicity and zero configuration
2. **Session-based Auth**: In-memory storage for development; production should use Redis
3. **Provider Pattern**: For state management in Flutter (recommended approach)
4. **Material Design 3**: Modern, accessible UI components

## 🏆 Assignment Requirements Met

| Requirement | Status | Implementation |
|------------|--------|----------------|
| Authentication System | ✅ | Username/password with session management |
| Text Field | ✅ | Job Title, Company Name, Description |
| Enum Field | ✅ | Difficulty dropdown (Easy/Medium/Hard) |
| Boolean Field | ✅ | Offer Received switch |
| Calculated Field | ✅ | Timeline Days (from 2 date inputs) |
| CRUD Operations | ✅ | Full Create, Read, Update, Delete |
| Pagination | ✅ | 10 items per page with controls |
| Filter | ✅ | By difficulty level |
| **Bonus**: Search | ✅ | Full-text search |
| **Bonus**: Sorting | ✅ | Multiple sort options |
| Clean Code | ✅ | OOP, modular, well-organized |
| Documentation | ✅ | Comprehensive README |
| AI Usage | ✅ | 6+ prompts documented |

## 📞 Support

For any issues or questions, please refer to the code comments or create an issue in the repository.

## 📄 License

This project is created for educational purposes as part of an AI Campus Assignment.

---

**Built with ❤️ using Flutter, Flask, and AI-assisted development**

