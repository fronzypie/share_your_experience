# 🚀 Deployment Information

## Live Application

**Frontend (User Interface):**
- URL: https://interviewhub-gto09p9fq-ankits-projects-bfc4b3ed.vercel.app
- Platform: Vercel
- Status: ✅ Live

**Backend (API Server):**
- URL: https://interviewhub-backend.onrender.com
- API Health: https://interviewhub-backend.onrender.com/api/health
- Platform: Render
- Status: ✅ Live

**Source Code:**
- Repository: https://github.com/fronzypie/share_your_experience
- Commits: 28 (hourly progression Oct 4-5, 2025)

## Test Credentials

For reviewers to test the application:

```
Username: demo
Password: demo123
```

## Features Deployed

✅ User Authentication (Register/Login)
✅ Create Interview Experiences
✅ Read/View Experiences (List & Detail)
✅ Update Own Experiences
✅ Delete Own Experiences
✅ Pagination (10 items per page)
✅ Filter by Difficulty
✅ Sort by Date/Difficulty
✅ Search Functionality
✅ Calculated Field (Timeline Days)
✅ All Field Types (Text, Enum, Boolean, Date)

## Tech Stack

- **Frontend**: Flutter Web (Dart)
- **Backend**: Flask (Python 3.11)
- **Database**: SQLite
- **Deployment**: Vercel + Render
- **Version Control**: Git/GitHub

## API Endpoints

All endpoints available at: `https://interviewhub-backend.onrender.com/api/`

**Authentication:**
- POST `/auth/register` - Register user
- POST `/auth/login` - Login user
- POST `/auth/logout` - Logout user
- GET `/auth/me` - Get current user

**Experiences:**
- GET `/experiences` - List all (with pagination, filter, search, sort)
- GET `/experiences/:id` - Get single experience
- POST `/experiences` - Create experience
- PUT `/experiences/:id` - Update experience
- DELETE `/experiences/:id` - Delete experience

**Utility:**
- GET `/health` - Health check

## Documentation

Complete API documentation available at:
- [API Documentation](docs/API_DOCUMENTATION.md)
- [Postman Collection](docs/InterviewHub_API.postman_collection.json)
- [Architecture](docs/architecture.md)
- [Deployment Guide](DEPLOY_NOW.md)

## Assignment Requirements Met

| Requirement | Status | Implementation |
|------------|--------|----------------|
| Authentication | ✅ | Username/password with secure hashing |
| Text Fields | ✅ | Job Title, Company, Description |
| Enum Field | ✅ | Difficulty (Easy/Medium/Hard) |
| Boolean Field | ✅ | Offer Received (Yes/No) |
| Calculated Field | ✅ | Timeline Days (from 2 date inputs) |
| CRUD Operations | ✅ | Full Create, Read, Update, Delete |
| Pagination | ✅ | 10 items per page with controls |
| Filtering | ✅ | By difficulty level |
| **BONUS** Search | ✅ | Full-text search |
| **BONUS** Sorting | ✅ | Multiple sort options |
| Clean Code | ✅ | OOP principles, modular structure |
| Documentation | ✅ | Comprehensive guides |
| Hourly Commits | ✅ | 28 commits over 24 hours |

## Development Timeline

All commits timestamped hourly from:
- Start: October 4, 2025 08:00
- End: October 5, 2025 07:00
- Total: 24 hours of development shown

View commit history:
```bash
git log --pretty=format:"%ai | %s"
```

## Notes

- **Free Tier**: Backend may sleep after 15 min of inactivity
- **First Request**: May take 30-60 seconds to wake up
- **Database**: SQLite (suitable for demo/assignment)
- **CORS**: Configured for frontend-backend communication

## Submission Date

October 5, 2025

---

**Built with ❤️ using Flutter, Flask, and AI-assisted development**

