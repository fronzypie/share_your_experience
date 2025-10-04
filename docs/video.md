# Demo Video Script

## 3-5 Minute Walkthrough

### Introduction (30 seconds)
"Hello! I'm going to demonstrate InterviewHub, a full-stack web application built with Flutter Web and Flask that allows users to share and discover interview experiences."

### 1. Application Overview (30 seconds)
- Show the landing page
- "The app features a clean, modern Material Design interface"
- "Built from scratch using Flutter for frontend and Flask with SQLite for backend"

### 2. Authentication Flow (1 minute)
- **Registration**:
  - Click "Sign Up"
  - Fill in username and password
  - Show validation (password must be 6+ characters)
  - Successfully register
  - "Passwords are securely hashed using Werkzeug"

- **Login**:
  - Login with credentials
  - "Session persists using bearer tokens"

### 3. Main Feed Features (1.5 minutes)
- **Experience List**:
  - Show paginated list of experiences
  - Point out key information: job title, company, difficulty badge, timeline

- **Search**:
  - Search for "Google" or "Engineer"
  - Show filtered results
  - "Full-text search across titles, companies, and descriptions"

- **Filter**:
  - Select "Medium" difficulty filter
  - Show filtered results

- **Sort**:
  - Change sort to "By Difficulty"
  - Show reordered list

- **Pagination**:
  - Click "Next" and "Previous" buttons
  - Show page numbers updating

### 4. CRUD Operations (1.5 minutes)
- **Create**:
  - Click "Share Your Experience" button
  - Fill out form:
    - Job Title: "Software Engineer"
    - Company: "Google"
    - Difficulty: "Medium"
    - Description: Brief interview experience
    - Offer Received: Toggle on
    - Application Date: Select date
    - Final Decision Date: Select date
  - "Notice the calculated timeline field updates automatically"
  - Submit the form
  - "This demonstrates the calculated field requirement - days derived from two date inputs"

- **Read**:
  - Click on the newly created experience
  - Show detailed view with all fields
  - Point out:
    - All text fields
    - Enum field (difficulty)
    - Boolean field (offer received)
    - Calculated field (timeline days)

- **Update**:
  - Click Edit button
  - Modify some fields
  - Submit
  - "Users can only edit their own posts"

- **Delete**:
  - Click Delete button
  - Show confirmation dialog
  - Confirm deletion
  - "Again, only the author can delete their posts"

### 5. Code Quality & Architecture (30 seconds)
- Briefly show code structure:
  - "Clean separation of concerns"
  - "Backend: SQLAlchemy models with relationships"
  - "Frontend: Provider for state management"
  - "RESTful API design"
  - "OOP principles: encapsulation, modularity"

### 6. Technical Highlights (30 seconds)
- "All assignment requirements met:"
  - ✅ Authentication system
  - ✅ Text, enum, boolean fields
  - ✅ Calculated field (timeline)
  - ✅ Full CRUD operations
  - ✅ Pagination (10 per page)
  - ✅ Filtering and sorting
  - ✅ Bonus: Search functionality

### Conclusion (20 seconds)
- "The application is fully functional and ready for deployment"
- "Comprehensive documentation included in README"
- "All code follows OOP principles and industry best practices"
- "Thank you!"

## Recording Tips

1. **Preparation**:
   - Have sample data in the database
   - Test the recording software
   - Practice the demo flow
   - Ensure backend and frontend are running

2. **During Recording**:
   - Speak clearly and at a moderate pace
   - Highlight key features as you interact
   - Keep the demo focused and concise
   - Show the calculated field working

3. **Editing**:
   - Trim any silent pauses
   - Add text overlays for key points
   - Ensure video is 3-5 minutes
   - Export in 1080p

4. **Upload**:
   - Upload to YouTube or similar
   - Make it unlisted or public
   - Add the link to your submission

## Screen Recording Commands

### macOS
```bash
# Built-in QuickTime
# Open QuickTime Player > File > New Screen Recording

# Or use ffmpeg
ffmpeg -f avfoundation -i "1:0" -r 30 -s 1920x1080 demo.mp4
```

### Windows
```bash
# Built-in Xbox Game Bar
# Press Win + G

# Or use OBS Studio (free)
```

### Linux
```bash
# Using ffmpeg
ffmpeg -f x11grab -s 1920x1080 -i :0.0 -r 30 demo.mp4
```

## Post-Recording

Save the video as `demo.mp4` in the `/docs` folder or upload to a video hosting service and include the link in your README.

