# Quick Start Guide

## Get Up and Running in 5 Minutes! ⚡

### Option 1: Automated Setup (Recommended)

```bash
# Clone/navigate to the project directory
cd share_your_experience

# Run the automated setup script
./setup.sh

# Start the backend (Terminal 1)
./run_backend.sh

# Start the frontend (Terminal 2 - in a new terminal window)
./run_frontend.sh
```

### Option 2: Manual Setup

#### Backend
```bash
cd share_your_experience/backend

# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # Mac/Linux
# or
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Run the server
python app.py
```

**Backend should be running on:** `http://localhost:5001` (Port 5001 to avoid macOS AirPlay Receiver on 5000)

#### Frontend
```bash
cd share_your_experience/frontend

# Get Flutter dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

**Frontend will open in Chrome automatically**

## First Time Usage

1. **Register an Account**
   - Click "Sign Up"
   - Enter a username and password (min 6 characters)
   - Click "Register"

2. **Create Your First Experience**
   - Click the "Share Your Experience" button
   - Fill out the form:
     - Job Title: e.g., "Software Engineer"
     - Company: e.g., "Google"
     - Difficulty: Select Easy/Medium/Hard
     - Description: Share your interview experience
     - Offer Received: Toggle on/off
     - Select application date and decision date
   - Click "Submit"

3. **Explore Features**
   - **Search**: Type keywords in the search bar
   - **Filter**: Select a difficulty level
   - **Sort**: Change sorting order
   - **Pagination**: Navigate through pages
   - **View Details**: Click on any experience card
   - **Edit/Delete**: Your own posts only

## Troubleshooting

### Backend Issues

**Error**: `ModuleNotFoundError: No module named 'flask'`
- **Solution**: Make sure you activated the virtual environment and ran `pip install -r requirements.txt`

**Error**: Port 5000 already in use
- **Solution**: Kill the existing process or change the port in `app.py`

### Frontend Issues

**Error**: `Flutter command not found`
- **Solution**: Install Flutter from https://flutter.dev

**Error**: `Dependencies not installed`
- **Solution**: Run `flutter pub get` in the frontend directory

**Error**: `Chrome not found`
- **Solution**: Install Chrome or use a different browser: `flutter run -d edge` or `flutter run -d safari`

## Default Configuration

- **Backend URL**: `http://localhost:5000`
- **Frontend URL**: Auto-assigned by Flutter (usually `http://localhost:<random-port>`)
- **Database**: SQLite file created automatically at `backend/share_your_experience.db`
- **Pagination**: 10 items per page

## Testing the API Directly

### Using curl

**Register a user:**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'
```

**Login:**
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'
```

**Get experiences:**
```bash
curl http://localhost:5000/api/experiences
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [docs/architecture.md](docs/architecture.md) for technical details
- Follow [docs/commits.md](docs/commits.md) for Git setup
- Review [docs/video.md](docs/video.md) for demo recording tips

## Need Help?

- Check the comprehensive README.md
- Review the architecture documentation
- Examine the code comments
- All routes and endpoints are documented in the backend code

## Quick Feature Checklist

- ✅ User registration and login
- ✅ Create interview experiences
- ✅ View all experiences (paginated)
- ✅ Search experiences
- ✅ Filter by difficulty
- ✅ Sort by date or difficulty
- ✅ View detailed experience
- ✅ Edit your own experiences
- ✅ Delete your own experiences
- ✅ Calculated timeline field
- ✅ Responsive UI

Happy coding! 🚀

