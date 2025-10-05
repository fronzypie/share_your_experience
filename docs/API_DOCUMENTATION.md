# API Documentation

## Base URLs

Development: `http://localhost:8000`  
Production: `https://interviewhub-backend.onrender.com`

Authentication is session-based using bearer tokens. Pretty standard stuff.

---

## Authentication

### Register a new user

`POST /api/auth/register`

Request:
```json
{
  "username": "johndoe",
  "password": "password123"
}
```

Returns a token on success that you'll need for authenticated endpoints.

Success (201):
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "username": "johndoe"
  },
  "token": "a1b2c3d4e5f6g7h8..."
}
```

Possible errors:
- 400: Username/password missing or password too short (needs 6+ chars)
- 409: Username already taken

Example:
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"johndoe","password":"password123"}'
```

---

### Login

`POST /api/auth/login`

Request:
```json
{
  "username": "johndoe",
  "password": "password123"
}
```

Returns the same structure as register - you get a token back.

Errors:
- 400: Missing credentials
- 401: Wrong username or password

---

### Logout

`POST /api/auth/logout`

Needs the Authorization header with your token:
```
Authorization: Bearer <your-token>
```

Just invalidates your session. Returns a simple success message.

---

### Get current user info

`GET /api/auth/me`

Returns your user info if you're logged in. Useful for checking if a token is still valid.

---

## Experiences

### List all experiences

`GET /api/experiences`

This is the main endpoint - it returns paginated experiences with a bunch of filtering options.

Query parameters (all optional):
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 10, max: 100)
- `difficulty` - Filter by Easy, Medium, or Hard
- `offer_received` - Filter by true/false
- `search` - Search across job title, company, and description
- `sort_by` - Options: `date_desc` (default), `date_asc`, or `difficulty`

Response includes the experiences array plus pagination metadata.

Example response:
```json
{
  "experiences": [
    {
      "id": 1,
      "job_title": "Software Engineer",
      "company_name": "Google",
      "experience_description": "Had 3 rounds of interviews...",
      "difficulty": "Hard",
      "offer_received": true,
      "application_date": "2024-09-01",
      "final_decision_date": "2024-09-30",
      "application_timeline_days": 29,
      "user_id": 1,
      "author_username": "johndoe",
      "created_at": "2024-10-01T10:30:00"
    }
  ],
  "total": 25,
  "page": 1,
  "per_page": 10,
  "pages": 3,
  "has_next": true,
  "has_prev": false
}
```

Examples:
```bash
# Basic
curl http://localhost:8000/api/experiences

# With filters
curl "http://localhost:8000/api/experiences?difficulty=Hard&search=google"

# Pagination
curl "http://localhost:8000/api/experiences?page=2&per_page=5"
```

---

### Get single experience

`GET /api/experiences/:id`

Returns detailed info for one experience. Pretty straightforward.

404 if the experience doesn't exist.

---

### Create experience

`POST /api/experiences`

**Requires authentication** - include your token in the Authorization header.

Request body:
```json
{
  "job_title": "Software Engineer",
  "company_name": "Google",
  "experience_description": "Had 3 rounds...",
  "difficulty": "Hard",
  "offer_received": true,
  "application_date": "2024-09-01",
  "final_decision_date": "2024-09-30"
}
```

All fields are required. A few notes:
- Difficulty must be exactly "Easy", "Medium", or "Hard"
- Dates should be YYYY-MM-DD format
- Final decision date can't be before application date (validation will catch this)
- The `application_timeline_days` field is calculated automatically from the two dates

Returns the created experience with a 201 status.

Errors:
- 400: Missing fields or invalid data
- 401: Not authenticated

Example:
```bash
curl -X POST http://localhost:8000/api/experiences \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "job_title": "Software Engineer",
    "company_name": "Google",
    "experience_description": "Great experience overall",
    "difficulty": "Hard",
    "offer_received": true,
    "application_date": "2024-09-01",
    "final_decision_date": "2024-09-30"
  }'
```

---

### Update experience

`PUT /api/experiences/:id`

**Requires authentication and ownership** - you can only update your own experiences.

All fields are optional - just send what you want to change:
```json
{
  "job_title": "Senior Software Engineer",
  "difficulty": "Medium"
}
```

Errors:
- 401: Not authenticated
- 403: Trying to edit someone else's experience
- 404: Experience doesn't exist

---

### Delete experience

`DELETE /api/experiences/:id`

**Requires authentication and ownership** - you can only delete your own posts.

Just returns a success message. Can't be undone, so the frontend should probably have a confirmation dialog.

Errors:
- 401: Not authenticated
- 403: Not your experience
- 404: Doesn't exist

---

## Health Check

`GET /api/health`

Simple endpoint to check if the API is running. Returns:
```json
{
  "status": "healthy"
}
```

Useful for monitoring or waking up the backend if you're on a free hosting tier that sleeps.

---

## Authentication Flow

Pretty standard bearer token auth:

1. Register or login to get a token
2. Store the token somewhere (localStorage works for this project)
3. Include it in the Authorization header for protected endpoints:
   ```
   Authorization: Bearer <your-token>
   ```
4. Token stays valid until you logout

Protected endpoints (need token):
- Creating, updating, or deleting experiences
- Getting current user info
- Logout

Public endpoints (no token needed):
- Viewing experiences (list and detail)
- Register
- Login
- Health check

---

## Response Format

Success responses are pretty straightforward - just the data you asked for.

Errors always look like this:
```json
{
  "error": "Description of what went wrong"
}
```

---

## HTTP Status Codes

Standard REST stuff:
- 200: Success
- 201: Created (for register and create experience)
- 400: Bad request (validation failed, missing fields, etc.)
- 401: Unauthorized (missing or invalid token)
- 403: Forbidden (authenticated but can't do this action)
- 404: Not found
- 409: Conflict (username already exists)
- 500: Server error (shouldn't happen but you know how it is)

---

## Data Models

### User
```typescript
{
  id: number;
  username: string;
}
```

### Experience
```typescript
{
  id: number;
  job_title: string;
  company_name: string;
  experience_description: string;
  difficulty: "Easy" | "Medium" | "Hard";
  offer_received: boolean;
  application_date: string; // YYYY-MM-DD
  final_decision_date: string; // YYYY-MM-DD
  application_timeline_days: number; // Calculated
  user_id: number;
  author_username: string;
  created_at: string; // ISO timestamp
}
```

---

## Testing

### Using cURL

Complete flow example:
```bash
# Register and save token
TOKEN=$(curl -s -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123"}' \
  | jq -r '.token')

# Create an experience
curl -X POST http://localhost:8000/api/experiences \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "job_title": "Backend Developer",
    "company_name": "Microsoft",
    "experience_description": "Good experience",
    "difficulty": "Medium",
    "offer_received": true,
    "application_date": "2024-08-01",
    "final_decision_date": "2024-08-20"
  }'

# Get all experiences
curl http://localhost:8000/api/experiences

# Logout
curl -X POST http://localhost:8000/api/auth/logout \
  -H "Authorization: Bearer $TOKEN"
```

### Using Python

```python
import requests

BASE_URL = "http://localhost:8000"

# Register
response = requests.post(f"{BASE_URL}/api/auth/register", json={
    "username": "testuser",
    "password": "test123"
})
token = response.json()["token"]

# Create experience
headers = {"Authorization": f"Bearer {token}"}
response = requests.post(
    f"{BASE_URL}/api/experiences",
    headers=headers,
    json={
        "job_title": "Software Engineer",
        "company_name": "Google",
        "experience_description": "Great experience",
        "difficulty": "Hard",
        "offer_received": True,
        "application_date": "2024-09-01",
        "final_decision_date": "2024-09-30"
    }
)
print(response.json())
```

### Using JavaScript

```javascript
const BASE_URL = 'http://localhost:8000';

// Register
const registerRes = await fetch(`${BASE_URL}/api/auth/register`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'testuser',
    password: 'test123'
  })
});
const { token } = await registerRes.json();

// Get experiences
const experiencesRes = await fetch(
  `${BASE_URL}/api/experiences?difficulty=Hard`,
  {
    headers: { 'Authorization': `Bearer ${token}` }
  }
);
const data = await experiencesRes.json();
console.log(data);
```

---

## Common Issues

**"Unauthorized" error**  
You forgot to include the token or it's expired. Re-login to get a new one.

**"Forbidden" error**  
You're trying to edit/delete someone else's experience. Only works on your own posts.

**Date validation errors**  
Make sure you're using YYYY-MM-DD format and that final decision date isn't before application date.

**Port conflicts**  
Backend runs on port 8000 by default. Changed it from 5000 because that port was taken by AirPlay on Mac.

**Backend sleeping**  
If you're using Render's free tier, the backend sleeps after 15 minutes of inactivity. First request might take 30-60 seconds to wake it up.

---

## Notes

The Postman collection in this repo has all these endpoints pre-configured if you want to test without writing code. Just import `InterviewHub_API.postman_collection.json` from the docs folder.

Sessions are stored in-memory on the backend, so restarting the server logs everyone out. For production you'd want Redis or something, but this works fine for the project.

The calculated timeline field is kind of cool - it automatically figures out how many days the interview process took based on the two dates you provide. No need to calculate it yourself.

---

*Last updated: October 2025*
