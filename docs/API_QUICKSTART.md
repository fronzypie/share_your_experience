# Quick API Testing Guide

Alright, so if you want to test the API quickly without firing up the whole frontend, here's what I usually do.

## What You Need

- Backend server running (should be on `http://localhost:8000`)
- Either cURL in your terminal, Postman, or any HTTP client really

## Super Quick Test (takes like 30 seconds)

### Step 1: Make sure it's alive

```bash
curl http://localhost:8000/api/health
```

You should get back:
```json
{"status": "healthy"}
```

If you don't see this, the backend isn't running. Go start it first!

### Step 2: Create a test user

```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","password":"demo123"}'
```

**Important:** Save the token you get back! You'll need it for the next steps.

### Step 3: Post an experience

```bash
# Don't forget to replace YOUR_TOKEN with what you got from step 2
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

### Step 4: Check if it's there

```bash
curl http://localhost:8000/api/experiences
```

You should see your post in the list!

## Using Postman (Way Easier IMO)

If you're not a terminal person, I set up a Postman collection that's already configured:

1. Open Postman
2. Click "Import" 
3. Choose `docs/InterviewHub_API.postman_collection.json` from this project
4. Set the `base_url` variable to `http://localhost:8000`
5. Start making requests!

The cool thing is the collection automatically saves your auth token after you login/register, so you don't have to copy-paste it everywhere.

## How Authentication Works

Pretty straightforward:
```
1. Register or Login → You get a token back
2. Save that token somewhere
3. For protected routes, add header: "Authorization: Bearer YOUR_TOKEN"
4. Make your requests
```

## Common Things You'll Want to Do

### Paginate through results

```bash
curl "http://localhost:8000/api/experiences?page=1&per_page=5"
```

### Search for something

```bash
curl "http://localhost:8000/api/experiences?search=google"
```

### Filter by how hard the interview was

```bash
curl "http://localhost:8000/api/experiences?difficulty=Hard"
```

### Combine everything

```bash
curl "http://localhost:8000/api/experiences?search=engineer&difficulty=Medium&sort_by=date_desc&page=1"
```

## What Responses Look Like

### When things work

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

### When they don't

```json
{
  "error": "Invalid username or password"
}
```

## More Info

- Full details: `docs/API_DOCUMENTATION.md`
- Postman setup: `docs/InterviewHub_API.postman_collection.json`
- Backend source: `backend/app.py`

## Quick Tips

1. Don't lose your token - you'll need it for creating/editing posts
2. HTTP codes matter - 200/201 means good, 400/401/403 means something went wrong
3. Use pagination! Don't try to load everything at once
4. Filtering helps reduce the data you're pulling

## When Things Break

**Backend not running?**
```bash
cd backend && python3 app.py
```

**Lost your token?**
Just login again, you'll get a fresh one

**Port already in use?**
Yeah, I moved it to 8000 because macOS loves to hog port 5000

---

That's pretty much it! Let me know if something doesn't work.

