# 🚀 API Quick Start Guide

Get started with the InterviewHub API in 5 minutes!

## 📋 Prerequisites

- Backend running on `http://localhost:8000`
- Tool of choice: cURL, Postman, or any HTTP client

## 🎯 Quick Test (30 seconds)

### 1. Check API is Running

```bash
curl http://localhost:8000/api/health
```

Expected response:
```json
{"status": "healthy"}
```

### 2. Register a User

```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"demo123"}'
```

Save the token from response!

### 3. Create an Experience

```bash
# Replace YOUR_TOKEN with the token from step 2
curl -X POST http://localhost:8000/api/experiences \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "job_title": "Software Engineer",
    "company_name": "Google",
    "experience_description": "Great interview experience!",
    "difficulty": "Medium",
    "offer_received": true,
    "application_date": "2024-09-01",
    "final_decision_date": "2024-09-20"
  }'
```

### 4. View All Experiences

```bash
curl http://localhost:8000/api/experiences
```

## 📦 Using Postman

### Import Collection

1. Open Postman
2. Click "Import"
3. Select `docs/InterviewHub_API.postman_collection.json`
4. Set `base_url` variable to `http://localhost:8000`
5. Run requests!

**Pro Tip:** The collection automatically saves your auth token after login/register!

## 🔑 Authentication Flow

```
1. Register/Login → Get Token
2. Save Token
3. Use Token in Header: "Authorization: Bearer YOUR_TOKEN"
4. Make Authenticated Requests
```

## 📝 Common Operations

### Get Paginated Experiences

```bash
curl "http://localhost:8000/api/experiences?page=1&per_page=5"
```

### Search

```bash
curl "http://localhost:8000/api/experiences?search=google"
```

### Filter by Difficulty

```bash
curl "http://localhost:8000/api/experiences?difficulty=Hard"
```

### Combined Query

```bash
curl "http://localhost:8000/api/experiences?search=engineer&difficulty=Medium&sort_by=date_desc&page=1"
```

## 🎨 Response Examples

### Success Response

```json
{
  "experience": {
    "id": 1,
    "job_title": "Software Engineer",
    "company_name": "Google",
    "difficulty": "Hard",
    "offer_received": true,
    "application_timeline_days": 29
  }
}
```

### Error Response

```json
{
  "error": "Invalid username or password"
}
```

## 🔗 Quick Links

- **Full API Docs:** `docs/API_DOCUMENTATION.md`
- **Postman Collection:** `docs/InterviewHub_API.postman_collection.json`
- **Backend Code:** `backend/app.py`

## 💡 Tips

1. **Save your token** - You'll need it for authenticated requests
2. **Check status codes** - 200/201 = success, 400/401/403 = errors
3. **Use pagination** - Don't fetch all data at once
4. **Filter and sort** - Reduce payload size

## 🆘 Troubleshooting

**Backend not responding?**
```bash
cd backend && python3 app.py
```

**Forgot your token?**
Just login again to get a new one!

**Port in use?**
Backend uses port 8000 (changed from 5000 to avoid macOS conflicts)

---

**Happy coding! 🎉**

