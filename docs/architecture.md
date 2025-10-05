# How This Thing is Built

So here's how I structured the whole application. It's a pretty standard web app setup, but I'll walk you through it.

## The Big Picture

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
│  │  • /api/auth/*  (Login/Register)                │   │
│  │  • /api/experiences/*  (All the CRUD stuff)     │   │
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

Pretty straightforward - browser talks to Flask, Flask talks to database. Nothing fancy.

## Frontend (Flutter Web)

### How I Organized the Code

```
frontend/lib/
├── main.dart                 # Where everything starts
├── models/                   # Data classes
│   ├── user.dart
│   └── experience.dart
├── services/                 # API calls and business logic
│   ├── api_service.dart      # Handles all HTTP requests
│   └── auth_service.dart     # Manages who's logged in
├── screens/                  # The actual pages
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── main_feed_screen.dart
│   ├── experience_detail_screen.dart
│   └── create_edit_experience_screen.dart
└── widgets/                  # Reusable components
    └── experience_card.dart
```

### State Management

I'm using Provider for state management. Basically:
- Services hold the state (like who's logged in, what data we have)
- Widgets listen to those services
- When something changes, widgets automatically rebuild

Also using SharedPreferences to save the auth token locally so you don't have to login every time.

### How Data Flows

```
User clicks something → Screen handles it → Calls a Service → 
Service talks to API → Gets response → Updates state → 
Screen rebuilds with new data
```

## Backend (Flask + Python)

### File Organization

```
backend/
├── app.py                    # Main Flask app (used to be one big file, now it's modular)
│   ├── Routes
│   ├── Models
│   └── Database setup
├── models/                   # Database models
│   ├── user.py
│   └── experience.py
├── services/                 # Business logic
│   ├── auth_service.py
│   └── experience_service.py
├── routes/                   # API endpoints
│   ├── auth_routes.py
│   └── experience_routes.py
├── utils/                    # Helper stuff
│   ├── validators.py
│   └── decorators.py
├── config.py                 # Configuration
└── requirements.txt          # Dependencies
```

### Database Models

#### User

Just the basics:
- ID (auto-generated)
- Username (unique)
- Password (hashed, obviously)
- Their posts (relationship to experiences)

Has methods to hash/check passwords and convert to JSON.

#### Experience

This is the main thing - interview experiences:
- ID
- Job title
- Company name  
- Description
- Difficulty (Easy/Medium/Hard)
- Whether they got an offer (true/false)
- Application date
- Final decision date
- Who posted it (foreign key to User)
- When it was created

The timeline (days between dates) is calculated automatically.

### API Endpoints

#### Auth Stuff
| What | Where | What it does | Need to be logged in? |
|------|-------|--------------|----------------------|
| POST | `/api/auth/register` | Make an account | Nope |
| POST | `/api/auth/login` | Log in | Nope |
| POST | `/api/auth/logout` | Log out | Yeah |
| GET | `/api/auth/me` | Check who you are | Yeah |

#### Experience Stuff
| What | Where | What it does | Need to be logged in? |
|------|-------|--------------|----------------------|
| GET | `/api/experiences` | See all posts | Nope |
| GET | `/api/experiences/:id` | See one post | Nope |
| POST | `/api/experiences` | Create a post | Yeah |
| PUT | `/api/experiences/:id` | Edit your post | Yeah (and it has to be yours) |
| DELETE | `/api/experiences/:id` | Delete your post | Yeah (and it has to be yours) |

#### Query Options for GET /api/experiences

You can add these to the URL:
- `page` - Which page (starts at 1)
- `per_page` - How many per page (default is 10)
- `difficulty` - Filter by Easy/Medium/Hard
- `search` - Search text
- `sort_by` - How to sort (date_desc, date_asc, difficulty)

### How Login Works

```
Client sends username/password
    ↓
Server checks if they're valid
    ↓
If good: Generate a random token, save it, send it back
    ↓
Client saves the token
    ↓
For protected routes: Client sends "Authorization: Bearer {token}"
    ↓
Server checks if token is valid
    ↓
If valid: Let them do the thing
```

### Session Tokens

Right now I'm just using Python's `secrets` module to generate random tokens and storing them in a dictionary. 

**Note:** This works for development but in production you'd want to use Redis or something that persists across server restarts.

## Database Setup

### How the Tables Relate

```
┌─────────────────────┐
│       User          │
├─────────────────────┤
│ id (primary key)    │
│ username (unique)   │
│ password_hash       │
└──────────┬──────────┘
           │
           │ One user can have many experiences
           │
┌──────────▼──────────┐
│    Experience       │
├─────────────────────┤
│ id (primary key)    │
│ job_title           │
│ company_name        │
│ description         │
│ difficulty          │
│ offer_received      │
│ application_date    │
│ final_decision_date │
│ user_id (foreign)   │
│ created_at          │
└─────────────────────┘
```

Simple one-to-many relationship. A user can post multiple experiences.

## Validation

### Frontend

I validate everything in the UI before even sending to the server:
- Username and password are required
- Password needs to be at least 6 characters
- Confirm password must match
- All the form fields are required
- Final date has to be after (or same as) application date

### Backend

I validate again on the server side (never trust the client!):
- Check if username is already taken
- Make sure password is strong enough
- Date logic makes sense
- Difficulty is actually Easy/Medium/Hard
- All required fields are there

## Security

Here's what I did to keep things secure:
1. **Passwords**: Hashed with Werkzeug (SHA-256) - never stored plain text
2. **Tokens**: Random 64-character hex strings
3. **Auth**: Bearer token in headers
4. **Ownership**: You can only edit/delete your own posts
5. **CORS**: Configured to allow the frontend domain

## Making it Fast

### Pagination
- Only send 10 items at a time by default
- Less data = faster load times
- Database doesn't have to fetch everything

### Database Indexes
- IDs are automatically indexed
- Username has an index because it's unique
- Foreign keys are indexed too

### Frontend Tricks
- Only use Stateful widgets when actually needed
- Provider handles efficient re-renders
- Validate on client side to avoid unnecessary API calls

## Deployment

### Where Things Should Go

```
┌─────────────────────────────────────────────┐
│         Static Hosting / CDN                │
│      (Netlify, Vercel, Firebase)            │
│          Flutter Web Build                  │
└──────────────────┬──────────────────────────┘
                   │
                   │ API Calls (HTTPS)
                   │
┌──────────────────▼──────────────────────────┐
│         Backend Server                       │
│      (Render, Heroku, etc.)                 │
│            Flask App                         │
└──────────────────┬──────────────────────────┘
                   │
                   │
┌──────────────────▼──────────────────────────┐
│         Database                             │
│   (SQLite file or upgrade to PostgreSQL)    │
└─────────────────────────────────────────────┘
```

Currently deployed:
- Frontend: Netlify
- Backend: Render
- Database: SQLite (on Render's server)

### Environment Variables You'll Need

- `SECRET_KEY` - For Flask sessions
- `DATABASE_URL` - If you upgrade from SQLite
- `FLASK_ENV` - Set to "production" when deploying

## What I'd Do Differently for Production

Right now it's good for an assignment/MVP, but for real production use:

1. **Session Storage**: Move from in-memory dict to Redis
2. **Database**: Switch from SQLite to PostgreSQL
3. **Caching**: Add Redis for frequently accessed data
4. **Load Balancing**: Put nginx in front
5. **CDN**: Serve static files through a CDN
6. **Monitoring**: Add error tracking (like Sentry)
7. **Backups**: Automated database backups
8. **HTTPS**: Enforce HTTPS everywhere
9. **Rate Limiting**: Prevent API abuse
10. **Testing**: Add unit and integration tests

## OOP Principles I Used

### Encapsulation
Models handle their own data and methods (like password hashing is inside the User model)

### Abstraction
Services hide the messy details - you just call `authService.login()` and don't worry about how it works

### Modularity
Everything has its own file and purpose - models, services, routes, utils all separated

### Inheritance
Flutter widgets extend StatefulWidget/StatelessWidget, SQLAlchemy models extend db.Model

## What Could Be Added Later

Some ideas I had but didn't implement (time constraints):

**Features:**
- User profiles with pictures
- Comments on experiences
- Upvote/downvote system
- Email notifications
- More filters (location, date range)
- Tags/categories

**Technical:**
- WebSockets for real-time updates
- File uploads
- Export to PDF
- OAuth (Google/LinkedIn login)
- Progressive Web App features
- Dark mode

**Analytics:**
- View counts
- Most interviewed companies
- Average difficulty by company
- Success rate stats

## Final Thoughts

The architecture is pretty standard for a modern web app. Nothing too crazy, just good separation of concerns and following best practices. Could definitely scale it up if needed, but for now it does what it needs to do.
