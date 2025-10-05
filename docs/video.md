# Demo Video Notes

These are my notes for recording the 3-5 minute walkthrough video. Mainly for my own reference but leaving it here in case it helps anyone else.

## The Video Plan (3-5 minutes total)

### Intro (30 seconds)
"Hey! This is InterviewHub - a full-stack web app I built where people can share their interview experiences. It's built with Flutter Web for the frontend and Flask/Python for the backend with a SQLite database."

Keep it casual, don't read from a script.

### Quick Overview (30 seconds)
- Show the main page
- "So it's got this clean Material Design interface"
- "Everything's built from scratch, no templates or anything"

### Authentication Demo (1 minute)

**Registration:**
- Click the Sign Up link
- Fill in a username and password
- Show the validation - try a short password first to show the error
- Then use a valid one and register successfully
- "Passwords are hashed using Werkzeug so they're never stored in plain text"

**Login:**
- Login with the account I just made
- "The session uses bearer tokens that persist in local storage"

### Main Feed Features (1.5 minutes)

Show off the main functionality:

**The List:**
- Scroll through some experiences
- Point out the info on each card - job title, company, difficulty badge, timeline
- "So each card shows the key info at a glance"

**Search:**
- Type something like "Google" or "Engineer" in the search bar
- Show the filtered results
- "Search works across job titles, companies, and descriptions"

**Filter:**
- Use the difficulty dropdown to filter by Medium
- Show how the list updates
- "Can filter by interview difficulty"

**Sort:**
- Try different sort options (by date, by difficulty)
- Show how the order changes
- "Sort by whatever makes sense for what you're looking for"

**Pagination:**
- Click through a few pages
- Show the page numbers
- "Paginated so it doesn't try to load everything at once"

### CRUD Operations Demo (1.5 minutes)

This is the important part for the assignment requirements.

**Create:**
- Click "Share Your Experience" button
- Fill out the form:
  - Job Title: "Software Engineer"
  - Company: "Amazon" (or whatever)
  - Difficulty: "Medium"
  - Description: "Write something brief but realistic"
  - Toggle the "Offer Received" switch to yes
  - Pick an application date
  - Pick a final decision date
- "See how the timeline field updates automatically? That's the calculated field requirement - it figures out the days between the two dates"
- Submit it
- "And there it is in the feed"

**Read:**
- Click on the experience I just created
- Show the detail page with everything
- Point out each type of field:
  - Text fields (title, company, description)
  - Enum field (difficulty dropdown)
  - Boolean field (offer received toggle)
  - Calculated field (timeline days)
- "So that covers all the required field types"

**Update:**
- Click the Edit button
- Change something (maybe the description or difficulty)
- Save it
- "You can only edit your own posts - if you try to edit someone else's it won't let you"

**Delete:**
- Click the Delete button
- Show the confirmation popup
- Actually delete it
- "Same with delete - only the person who posted it can remove it"

### Quick Code Mention (30 seconds)

Optional - only if there's time:
- Briefly show the project structure
- "Clean separation - models, services, routes"
- "Backend uses SQLAlchemy models with relationships"
- "Frontend uses Provider for state management"
- "RESTful API design"
- "Following OOP principles throughout"

### Wrap Up Requirements (30 seconds)
"So that covers everything required for the assignment:"
- ✅ Authentication system with hashed passwords
- ✅ Text fields, enum, boolean fields
- ✅ Calculated field (timeline days)
- ✅ Full CRUD operations
- ✅ Pagination (10 items per page)
- ✅ Filtering by difficulty
- ✅ Sorting options
- ✅ Plus bonus search functionality

"Everything's deployed and working, documentation's in the README. Thanks for watching!"

## Recording Tips (Notes to Self)

**Before recording:**
- Make sure backend and frontend are both running
- Have some sample data already in the database
- Close unnecessary tabs/apps
- Test the screen recording software first
- Maybe do a practice run?

**While recording:**
- Speak clearly but naturally
- Don't go too fast - give things time to load
- If something breaks, just start over (happens)
- Make sure to actually show the calculated field working
- Don't forget to mention the field types

**After recording:**
- Trim any dead air at start/end
- Can add text overlays if needed ("CRUD Operations", etc.)
- Keep it 3-5 minutes - don't go over
- Export at 1080p
- Check audio levels

**Upload:**
- YouTube works fine (can set to unlisted)
- Add the link to README
- Maybe add timestamps in the description

## Screen Recording Commands

### macOS (what I'm using)
```bash
# QuickTime is built-in
# Just open QuickTime Player > File > New Screen Recording

# Or if you have ffmpeg:
ffmpeg -f avfoundation -i "1:0" -r 30 -s 1920x1080 demo.mp4
```

### Windows
```bash
# Xbox Game Bar is built-in
# Press Win + G

# Or OBS Studio (free and works great)
```

### Linux
```bash
ffmpeg -f x11grab -s 1920x1080 -i :0.0 -r 30 demo.mp4
```

## What Actually Matters

The assignment wants to see:
1. The app actually works
2. All required features are there
3. CRUD operations work correctly
4. The calculated field exists
5. Code is clean and organized

So focus on showing those things clearly. The video doesn't have to be fancy, just functional.

---

Alright, that's the plan. Should be straightforward to record once I get everything set up.
