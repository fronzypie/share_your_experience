# 📡 API Documentation - InterviewHub Backend

**Base URL (Local):** `http://localhost:8000`  
**Base URL (Production):** `https://your-domain.com`

**Version:** 1.0.0  
**Authentication:** Bearer Token (Session-based)

---

## 📑 Table of Contents

1. [Authentication Endpoints](#authentication-endpoints)
2. [Experience Endpoints](#experience-endpoints)
3. [Response Formats](#response-formats)
4. [Error Codes](#error-codes)
5. [Examples](#examples)

---

## 🔐 Authentication Endpoints

### 1. Register User

Create a new user account.

**Endpoint:** `POST /api/auth/register`

**Request Headers:**
```http
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "johndoe",
  "password": "password123"
}
```

**Validation Rules:**
- `username`: Required, string, unique
- `password`: Required, string, minimum 6 characters

**Success Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "username": "johndoe"
  },
  "token": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
}
```

**Error Responses:**

*400 Bad Request:*
```json
{
  "error": "Username and password are required"
}
```

*400 Bad Request:*
```json
{
  "error": "Password must be at least 6 characters long"
}
```

*409 Conflict:*
```json
{
  "error": "Username already exists"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "password": "password123"
  }'
```

---

### 2. Login User

Authenticate a user and receive a session token.

**Endpoint:** `POST /api/auth/login`

**Request Headers:**
```http
Content-Type: application/json
```

**Request Body:**
```json
{
  "username": "johndoe",
  "password": "password123"
}
```

**Success Response (200 OK):**
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "johndoe"
  },
  "token": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
}
```

**Error Responses:**

*400 Bad Request:*
```json
{
  "error": "Username and password are required"
}
```

*401 Unauthorized:*
```json
{
  "error": "Invalid username or password"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "password": "password123"
  }'
```

---

### 3. Logout User

Invalidate the current session token.

**Endpoint:** `POST /api/auth/logout`

**Request Headers:**
```http
Authorization: Bearer <token>
```

**Success Response (200 OK):**
```json
{
  "message": "Logout successful"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:8000/api/auth/logout \
  -H "Authorization: Bearer a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
```

---

### 4. Get Current User

Retrieve information about the currently authenticated user.

**Endpoint:** `GET /api/auth/me`

**Request Headers:**
```http
Authorization: Bearer <token>
```

**Success Response (200 OK):**
```json
{
  "user": {
    "id": 1,
    "username": "johndoe"
  }
}
```

**Error Responses:**

*401 Unauthorized:*
```json
{
  "error": "Unauthorized"
}
```

*401 Unauthorized:*
```json
{
  "error": "Invalid or expired session"
}
```

**cURL Example:**
```bash
curl -X GET http://localhost:8000/api/auth/me \
  -H "Authorization: Bearer a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
```

---

## 📝 Experience Endpoints

### 5. Get All Experiences (Paginated)

Retrieve a paginated list of interview experiences with optional filtering, sorting, and search.

**Endpoint:** `GET /api/experiences`

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `page` | integer | No | 1 | Page number |
| `per_page` | integer | No | 10 | Items per page (max 100) |
| `difficulty` | string | No | - | Filter by difficulty (Easy, Medium, Hard) |
| `offer_received` | boolean | No | - | Filter by offer status (true/false) |
| `search` | string | No | - | Search term for job title, company, or description |
| `sort_by` | string | No | date_desc | Sort order (date_desc, date_asc, difficulty) |

**Success Response (200 OK):**
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

**cURL Examples:**

*Basic request:*
```bash
curl -X GET http://localhost:8000/api/experiences
```

*With pagination:*
```bash
curl -X GET "http://localhost:8000/api/experiences?page=2&per_page=5"
```

*With filtering:*
```bash
curl -X GET "http://localhost:8000/api/experiences?difficulty=Medium&offer_received=true"
```

*With search:*
```bash
curl -X GET "http://localhost:8000/api/experiences?search=google"
```

*With sorting:*
```bash
curl -X GET "http://localhost:8000/api/experiences?sort_by=difficulty"
```

*Combined:*
```bash
curl -X GET "http://localhost:8000/api/experiences?page=1&difficulty=Hard&search=engineer&sort_by=date_desc"
```

---

### 6. Get Single Experience

Retrieve detailed information about a specific experience.

**Endpoint:** `GET /api/experiences/:id`

**Path Parameters:**
- `id` (integer): Experience ID

**Success Response (200 OK):**
```json
{
  "experience": {
    "id": 1,
    "job_title": "Software Engineer",
    "company_name": "Google",
    "experience_description": "Had 3 rounds of interviews including coding, system design, and behavioral. The coding round was challenging with LeetCode hard problems...",
    "difficulty": "Hard",
    "offer_received": true,
    "application_date": "2024-09-01",
    "final_decision_date": "2024-09-30",
    "application_timeline_days": 29,
    "user_id": 1,
    "author_username": "johndoe",
    "created_at": "2024-10-01T10:30:00"
  }
}
```

**Error Response:**

*404 Not Found:*
```json
{
  "error": "Experience not found"
}
```

**cURL Example:**
```bash
curl -X GET http://localhost:8000/api/experiences/1
```

---

### 7. Create Experience

Create a new interview experience (requires authentication).

**Endpoint:** `POST /api/experiences`

**Request Headers:**
```http
Content-Type: application/json
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "job_title": "Software Engineer",
  "company_name": "Google",
  "experience_description": "Had 3 rounds of interviews including coding, system design, and behavioral...",
  "difficulty": "Hard",
  "offer_received": true,
  "application_date": "2024-09-01",
  "final_decision_date": "2024-09-30"
}
```

**Validation Rules:**
- `job_title`: Required, string
- `company_name`: Required, string
- `experience_description`: Required, string
- `difficulty`: Required, enum (Easy, Medium, Hard)
- `offer_received`: Required, boolean
- `application_date`: Required, date (YYYY-MM-DD)
- `final_decision_date`: Required, date (YYYY-MM-DD), must be >= application_date

**Success Response (201 Created):**
```json
{
  "message": "Experience created successfully",
  "experience": {
    "id": 5,
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
    "created_at": "2024-10-04T15:45:00"
  }
}
```

**Error Responses:**

*401 Unauthorized:*
```json
{
  "error": "Unauthorized"
}
```

*400 Bad Request:*
```json
{
  "error": "Missing required field: job_title"
}
```

*400 Bad Request:*
```json
{
  "error": "Difficulty must be Easy, Medium, or Hard"
}
```

*400 Bad Request:*
```json
{
  "error": "Final decision date cannot be before application date"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:8000/api/experiences \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6" \
  -d '{
    "job_title": "Software Engineer",
    "company_name": "Google",
    "experience_description": "Had 3 rounds of interviews...",
    "difficulty": "Hard",
    "offer_received": true,
    "application_date": "2024-09-01",
    "final_decision_date": "2024-09-30"
  }'
```

---

### 8. Update Experience

Update an existing experience (requires authentication and ownership).

**Endpoint:** `PUT /api/experiences/:id`

**Request Headers:**
```http
Content-Type: application/json
Authorization: Bearer <token>
```

**Path Parameters:**
- `id` (integer): Experience ID

**Request Body:**
```json
{
  "job_title": "Senior Software Engineer",
  "difficulty": "Medium"
}
```

**Note:** All fields are optional. Only send fields you want to update.

**Success Response (200 OK):**
```json
{
  "message": "Experience updated successfully",
  "experience": {
    "id": 1,
    "job_title": "Senior Software Engineer",
    "company_name": "Google",
    "experience_description": "Had 3 rounds of interviews...",
    "difficulty": "Medium",
    "offer_received": true,
    "application_date": "2024-09-01",
    "final_decision_date": "2024-09-30",
    "application_timeline_days": 29,
    "user_id": 1,
    "author_username": "johndoe",
    "created_at": "2024-10-01T10:30:00"
  }
}
```

**Error Responses:**

*401 Unauthorized:*
```json
{
  "error": "Unauthorized"
}
```

*403 Forbidden:*
```json
{
  "error": "Forbidden: You can only edit your own experiences"
}
```

*404 Not Found:*
```json
{
  "error": "Experience not found"
}
```

**cURL Example:**
```bash
curl -X PUT http://localhost:8000/api/experiences/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6" \
  -d '{
    "job_title": "Senior Software Engineer",
    "difficulty": "Medium"
  }'
```

---

### 9. Delete Experience

Delete an experience (requires authentication and ownership).

**Endpoint:** `DELETE /api/experiences/:id`

**Request Headers:**
```http
Authorization: Bearer <token>
```

**Path Parameters:**
- `id` (integer): Experience ID

**Success Response (200 OK):**
```json
{
  "message": "Experience deleted successfully"
}
```

**Error Responses:**

*401 Unauthorized:*
```json
{
  "error": "Unauthorized"
}
```

*403 Forbidden:*
```json
{
  "error": "Forbidden: You can only delete your own experiences"
}
```

*404 Not Found:*
```json
{
  "error": "Experience not found"
}
```

**cURL Example:**
```bash
curl -X DELETE http://localhost:8000/api/experiences/1 \
  -H "Authorization: Bearer a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6"
```

---

### 10. Health Check

Check if the API is running.

**Endpoint:** `GET /api/health`

**Success Response (200 OK):**
```json
{
  "status": "healthy"
}
```

**cURL Example:**
```bash
curl -X GET http://localhost:8000/api/health
```

---

## 📊 Response Formats

### Success Response Structure

All successful responses follow this general structure:

```json
{
  "data": { ... },          // Main response data
  "message": "Success",     // Optional success message
  "metadata": { ... }       // Optional metadata (pagination, etc.)
}
```

### Error Response Structure

All error responses follow this structure:

```json
{
  "error": "Error message describing what went wrong"
}
```

---

## ⚠️ Error Codes

| HTTP Status | Meaning | Common Causes |
|-------------|---------|---------------|
| 200 | OK | Request successful |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid input, validation failed |
| 401 | Unauthorized | Missing or invalid authentication token |
| 403 | Forbidden | Authenticated but not authorized for this action |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Resource already exists (e.g., duplicate username) |
| 500 | Internal Server Error | Server-side error |

---

## 🔒 Authentication Flow

1. **Register or Login** to receive a token
2. **Store the token** securely (localStorage, sessionStorage, etc.)
3. **Include token** in Authorization header for protected endpoints:
   ```
   Authorization: Bearer <your-token-here>
   ```
4. **Token expires** when user logs out or session is invalidated

**Protected Endpoints:**
- POST `/api/experiences` (Create)
- PUT `/api/experiences/:id` (Update)
- DELETE `/api/experiences/:id` (Delete)
- POST `/api/auth/logout` (Logout)
- GET `/api/auth/me` (Get current user)

**Public Endpoints:**
- GET `/api/experiences` (List)
- GET `/api/experiences/:id` (View single)
- POST `/api/auth/register` (Register)
- POST `/api/auth/login` (Login)
- GET `/api/health` (Health check)

---

## 💡 Examples

### Example 1: Complete User Flow

```bash
# 1. Register
TOKEN=$(curl -s -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123"}' \
  | jq -r '.token')

# 2. Create an experience
curl -X POST http://localhost:8000/api/experiences \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "job_title": "Backend Developer",
    "company_name": "Microsoft",
    "experience_description": "Great experience overall",
    "difficulty": "Medium",
    "offer_received": true,
    "application_date": "2024-08-01",
    "final_decision_date": "2024-08-20"
  }'

# 3. View all experiences
curl -X GET http://localhost:8000/api/experiences

# 4. Logout
curl -X POST http://localhost:8000/api/auth/logout \
  -H "Authorization: Bearer $TOKEN"
```

### Example 2: Search and Filter

```bash
# Search for "Google" experiences with Hard difficulty
curl -X GET "http://localhost:8000/api/experiences?search=google&difficulty=Hard&sort_by=date_desc"
```

### Example 3: Update Workflow

```bash
# Get experience ID 5
EXPERIENCE=$(curl -s http://localhost:8000/api/experiences/5)

# Update it
curl -X PUT http://localhost:8000/api/experiences/5 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"difficulty":"Easy","offer_received":true}'
```

---

## 📦 Data Models

### User Model
```typescript
{
  id: number;
  username: string;
}
```

### Experience Model
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
  application_timeline_days: number; // Calculated field
  user_id: number;
  author_username: string;
  created_at: string; // ISO 8601 format
}
```

### Pagination Metadata
```typescript
{
  total: number;        // Total number of items
  page: number;         // Current page
  per_page: number;     // Items per page
  pages: number;        // Total pages
  has_next: boolean;    // Has next page
  has_prev: boolean;    // Has previous page
}
```

---

## 🧪 Testing the API

### Using Postman

1. Import the endpoints above
2. Create environment variables:
   - `base_url`: `http://localhost:8000`
   - `token`: Your authentication token
3. Use `{{base_url}}` and `{{token}}` in requests

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

### Using JavaScript/Fetch

```javascript
const BASE_URL = 'http://localhost:8000';

// Register
const response = await fetch(`${BASE_URL}/api/auth/register`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'testuser',
    password: 'test123'
  })
});
const { token } = await response.json();

// Get experiences
const experiences = await fetch(`${BASE_URL}/api/experiences?page=1&difficulty=Hard`, {
  headers: { 'Authorization': `Bearer ${token}` }
});
console.log(await experiences.json());
```

---

## 📚 Additional Resources

- **Source Code:** `backend/app.py`
- **Deployment Guide:** `DEPLOYMENT.md`
- **Architecture:** `docs/architecture.md`
- **README:** `README.md`

---

## 🆘 Support

For issues or questions:
1. Check the error message in the response
2. Review the validation rules
3. Verify authentication token is included
4. Check the server logs for details

**Common Issues:**

| Issue | Solution |
|-------|----------|
| "Unauthorized" | Include valid token in Authorization header |
| "Forbidden" | Trying to edit/delete someone else's experience |
| "Invalid date format" | Use YYYY-MM-DD format |
| "Username already exists" | Choose a different username |
| "Port already in use" | Backend uses port 8000 |

---

**API Version:** 1.0.0  
**Last Updated:** October 4, 2024  
**Maintained by:** InterviewHub Team

