# InterviewHub - Share Your Experience

A web platform where people can share their interview experiences and learn from others. I built this using Flutter for the frontend and Flask for the backend.

## Demo

**Live Application:** https://darling-axolotl-ce4cbd.netlify.app

**Demo Video:** [Watch on YouTube](https://youtu.be/-fTT1_u8nGs)

## What This Project Does

InterviewHub lets users share detailed interview experiences - what company they interviewed with, how difficult it was, whether they got an offer, and all the details that might help someone else preparing for interviews. Think of it like a community knowledge base for interview prep.

The main features are:
- User accounts (register and login)
- Post your interview experiences
- Browse what others have posted
- Search and filter to find relevant experiences
- Edit or delete your own posts

## Tech Stack

I went with Flutter Web for the frontend because I wanted to learn Flutter and it seemed like a good way to build a modern web UI. The backend is Flask (Python) which I'm more comfortable with. Database is SQLite - simple and gets the job done for a project like this.

**Frontend:**
- Flutter Web
- Provider for state management
- Material Design 3 for the UI

**Backend:**
- Flask (Python)
- SQLAlchemy ORM
- SQLite database
- Session-based authentication

## Project Structure

```
share_your_experience/
├── backend/
│   ├── app.py                      # Main Flask app
│   ├── config.py                   # Configuration settings
│   ├── models/                     # Database models
│   ├── services/                   # Business logic
│   ├── routes/                     # API endpoints
│   ├── utils/                      # Helper functions
│   └── requirements.txt
│
└── frontend/
    ├── lib/
    │   ├── main.dart
    │   ├── models/                 # Data models
    │   ├── services/               # API calls
    │   ├── screens/                # UI screens
    │   └── widgets/                # Reusable components
    ├── web/
    └── pubspec.yaml
```

## Getting Started

### Backend Setup

1. Navigate to backend folder:
```bash
cd backend
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

3. Run the server:
```bash
python3 app.py
```

The backend should start on `http://localhost:8000` (I changed it from 5000 because that port was conflicting with AirPlay on Mac).

### Frontend Setup

1. Go to frontend folder:
```bash
cd frontend
```

2. Get Flutter dependencies:
```bash
flutter pub get
```

3. Run it:
```bash
flutter run -d chrome
```

Or build for deployment:
```bash
flutter build web
```

## Features I Implemented

### Authentication
Pretty standard username/password authentication. Passwords are hashed (using Werkzeug) and sessions are managed with bearer tokens. Not the most sophisticated auth system but it works for this project.

### CRUD Operations
Full create, read, update, delete functionality for interview experiences. Users can only edit/delete their own posts which makes sense.

### Required Fields
The assignment needed specific field types, so here's what I included:
- **Text fields**: Job title, company name, and a description of the experience
- **Enum field**: Difficulty selector (Easy, Medium, or Hard)
- **Boolean field**: Whether they got an offer or not
- **Calculated field**: This was interesting - it automatically calculates the number of days between when you applied and when you got the final decision

### Pagination and Filtering
The main feed shows 10 experiences per page. You can filter by difficulty level and sort by date or difficulty. I also added a search feature (not required but seemed useful) that searches across job titles, companies, and descriptions.

## API Endpoints

The backend exposes these endpoints:

**Auth stuff:**
- `POST /api/auth/register` - Create an account
- `POST /api/auth/login` - Login and get a token
- `POST /api/auth/logout` - Logout
- `GET /api/auth/me` - Get current user info

**Experience CRUD:**
- `GET /api/experiences` - List all experiences (with pagination, filters, search)
- `GET /api/experiences/:id` - Get one specific experience
- `POST /api/experiences` - Create new (requires login)
- `PUT /api/experiences/:id` - Update (requires login + ownership)
- `DELETE /api/experiences/:id` - Delete (requires login + ownership)

More detailed API docs are in the `docs/` folder if you need them.

## Code Structure

I refactored the backend to follow better practices - separated models, services, routes, and utilities into different folders instead of having everything in one huge file. The frontend follows Flutter's recommended structure with separate folders for models, services, screens, and widgets.

### OOP Concepts
Since the assignment required demonstrating OOP:
- Models encapsulate data and behavior
- Service classes handle business logic
- Clear separation between data, logic, and presentation layers
- Used inheritance for configuration classes
- Decorator pattern for authentication

## Deployment

The app is deployed and accessible at:
- **Frontend**: https://darling-axolotl-ce4cbd.netlify.app
- **Backend**: https://interviewhub-backend.onrender.com

Backend is on Render's free tier and frontend on Netlify. First request might take a minute because free tier backends sleep after inactivity.

### To deploy your own:

**Backend (Render):**
1. Connect your GitHub repo
2. Create a new Web Service
3. Point it to the `backend` folder
4. It should auto-detect the Python app

**Frontend (Netlify):**
1. Build locally: `flutter build web`
2. Deploy the `build/web` folder to Netlify
3. Can use their CLI or drag-and-drop

## Development Notes

Some things I learned while building this:

1. **Port conflicts**: Had to change the backend port to 8000 because 5000 and 5001 were already taken on Mac (AirPlay and Control Center respectively).

2. **Flutter Web quirks**: The Flutter web initialization needed some tweaking. Had to use `flutter_bootstrap.js` instead of the older `flutter.js`.

3. **CORS issues**: Spent some time figuring out CORS configuration to let the frontend talk to the backend.

4. **State management**: Used Provider pattern for Flutter state management. Took a bit to wrap my head around it but makes sense now.

5. **Modular architecture**: Initially had everything in one `app.py` file, but refactored it into a proper modular structure with separate concerns. Much cleaner.

## Testing

To test the app:
1. Create an account on the deployed version
2. Try creating an interview experience
3. Test the search and filter features
4. Try editing/deleting your posts

Some sample accounts are already there with test data if you want to see what experiences look like.

## Assignment Requirements

Just to confirm everything's covered:

| Requirement | Done? | Where |
|------------|-------|-------|
| Authentication | ✓ | Login/register system |
| Text fields | ✓ | Job title, company, description |
| Enum field | ✓ | Difficulty dropdown |
| Boolean field | ✓ | Offer received toggle |
| Calculated field | ✓ | Timeline days |
| CRUD | ✓ | Full create/read/update/delete |
| Pagination | ✓ | 10 per page |
| Filtering | ✓ | By difficulty |
| OOP concepts | ✓ | Models, services, inheritance, encapsulation |
| Clean code | ✓ | Modular structure, comments |

Extra features I added:
- Search functionality
- Multiple sort options
- Responsive UI
- API documentation

## Files Worth Looking At

If you're reviewing the code:
- `backend/models/` - Database models
- `backend/services/` - Business logic separated from routes
- `frontend/lib/screens/` - All the UI screens
- `frontend/lib/services/api_service.dart` - How frontend talks to backend

## Known Issues

- Backend needs ~30 seconds to wake up on first request (free tier limitation)
- SQLite isn't ideal for production but works fine for this project
- Session storage is in-memory, so restarting the backend logs everyone out

## What I'd Do Differently

If I were to rebuild this:
- Maybe use PostgreSQL instead of SQLite for a more realistic setup
- Add Redis for session storage
- Implement refresh tokens instead of just bearer tokens
- Add unit tests
- Maybe add image upload for company logos

But for the scope of this assignment, I think it covers everything pretty well.

## Resources

Documentation I created:
- `docs/API_DOCUMENTATION.md` - Detailed API reference
- `backend/README_ARCHITECTURE.md` - Explanation of the backend structure
- `OOP_REFACTORING_SUMMARY.md` - How I refactored to OOP principles

## Running Locally

Quick start:
```bash
# Terminal 1 - Backend
cd backend
pip install -r requirements.txt
python3 app.py

# Terminal 2 - Frontend
cd frontend
flutter pub get
flutter run -d chrome
```

That's pretty much it. The project demonstrates full-stack development with proper authentication, CRUD operations, and clean architecture. Feel free to check out the deployed version or run it locally.
