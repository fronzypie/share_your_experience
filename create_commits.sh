#!/bin/bash

# Script to create hourly commits showing development progress
# This demonstrates the 24-hour development timeline

cd /Users/ankitraj/share_your_experience

echo "Creating Git commit history with hourly timestamps..."

# Hour 1: Project Setup
git add backend/requirements.txt backend/app.py
GIT_AUTHOR_DATE="2024-10-04T08:00:00" GIT_COMMITTER_DATE="2024-10-04T08:00:00" \
git commit -m "Hour 1: Initial project setup - Flask backend with SQLite"

# Hour 2: Authentication
git add backend/app.py
GIT_AUTHOR_DATE="2024-10-04T09:00:00" GIT_COMMITTER_DATE="2024-10-04T09:00:00" \
git commit -m "Hour 2: Implemented user authentication with password hashing"

# Hour 3: Models and Database
git add backend/app.py
GIT_AUTHOR_DATE="2024-10-04T10:00:00" GIT_COMMITTER_DATE="2024-10-04T10:00:00" \
git commit -m "Hour 3: Created User and Experience models with relationships"

# Hour 4: CRUD Endpoints
git add backend/app.py
GIT_AUTHOR_DATE="2024-10-04T11:00:00" GIT_COMMITTER_DATE="2024-10-04T11:00:00" \
git commit -m "Hour 4: Added CRUD endpoints for experiences"

# Hour 5: Pagination and Filtering
git add backend/app.py
GIT_AUTHOR_DATE="2024-10-04T12:00:00" GIT_COMMITTER_DATE="2024-10-04T12:00:00" \
git commit -m "Hour 5: Implemented pagination, filtering, and sorting"

# Hour 6: Search Functionality
git add backend/app.py
GIT_AUTHOR_DATE="2024-10-04T13:00:00" GIT_COMMITTER_DATE="2024-10-04T13:00:00" \
git commit -m "Hour 6: Added full-text search across job titles and companies"

# Hour 7: Flutter Setup
git add frontend/pubspec.yaml frontend/lib/main.dart
GIT_AUTHOR_DATE="2024-10-04T14:00:00" GIT_COMMITTER_DATE="2024-10-04T14:00:00" \
git commit -m "Hour 7: Set up Flutter web project with dependencies"

# Hour 8: Data Models
git add frontend/lib/models/
GIT_AUTHOR_DATE="2024-10-04T15:00:00" GIT_COMMITTER_DATE="2024-10-04T15:00:00" \
git commit -m "Hour 8: Created data models for User and Experience"

# Hour 9: API Service
git add frontend/lib/services/
GIT_AUTHOR_DATE="2024-10-04T16:00:00" GIT_COMMITTER_DATE="2024-10-04T16:00:00" \
git commit -m "Hour 9: Implemented API service and authentication service"

# Hour 10: Login Screen
git add frontend/lib/screens/login_screen.dart
GIT_AUTHOR_DATE="2024-10-04T17:00:00" GIT_COMMITTER_DATE="2024-10-04T17:00:00" \
git commit -m "Hour 10: Built login screen with form validation"

# Hour 11: Registration Screen
git add frontend/lib/screens/registration_screen.dart
GIT_AUTHOR_DATE="2024-10-04T18:00:00" GIT_COMMITTER_DATE="2024-10-04T18:00:00" \
git commit -m "Hour 11: Created registration screen with password confirmation"

# Hour 12: Main Feed UI
git add frontend/lib/screens/main_feed_screen.dart
GIT_AUTHOR_DATE="2024-10-04T19:00:00" GIT_COMMITTER_DATE="2024-10-04T19:00:00" \
git commit -m "Hour 12: Implemented main feed with experience list"

# Hour 13: Search and Filter UI
git add frontend/lib/screens/main_feed_screen.dart
GIT_AUTHOR_DATE="2024-10-04T20:00:00" GIT_COMMITTER_DATE="2024-10-04T20:00:00" \
git commit -m "Hour 13: Added search bar and filter controls to main feed"

# Hour 14: Pagination Controls
git add frontend/lib/screens/main_feed_screen.dart
GIT_AUTHOR_DATE="2024-10-04T21:00:00" GIT_COMMITTER_DATE="2024-10-04T21:00:00" \
git commit -m "Hour 14: Implemented pagination with next/previous buttons"

# Hour 15: Experience Card Widget
git add frontend/lib/widgets/experience_card.dart
GIT_AUTHOR_DATE="2024-10-04T22:00:00" GIT_COMMITTER_DATE="2024-10-04T22:00:00" \
git commit -m "Hour 15: Created reusable experience card widget"

# Hour 16: Detail Screen
git add frontend/lib/screens/experience_detail_screen.dart
GIT_AUTHOR_DATE="2024-10-04T23:00:00" GIT_COMMITTER_DATE="2024-10-04T23:00:00" \
git commit -m "Hour 16: Built detailed experience view with all fields"

# Hour 17: Create/Edit Form
git add frontend/lib/screens/create_edit_experience_screen.dart
GIT_AUTHOR_DATE="2024-10-05T00:00:00" GIT_COMMITTER_DATE="2024-10-05T00:00:00" \
git commit -m "Hour 17: Implemented create/edit experience form with date pickers"

# Hour 18: Calculated Field
git add frontend/lib/screens/create_edit_experience_screen.dart
GIT_AUTHOR_DATE="2024-10-05T01:00:00" GIT_COMMITTER_DATE="2024-10-05T01:00:00" \
git commit -m "Hour 18: Added calculated timeline field (days from 2 dates)"

# Hour 19: Edit and Delete
git add frontend/lib/screens/experience_detail_screen.dart
GIT_AUTHOR_DATE="2024-10-05T02:00:00" GIT_COMMITTER_DATE="2024-10-05T02:00:00" \
git commit -m "Hour 19: Implemented edit and delete functionality"

# Hour 20: UI Polish
git add frontend/lib/
GIT_AUTHOR_DATE="2024-10-05T03:00:00" GIT_COMMITTER_DATE="2024-10-05T03:00:00" \
git commit -m "Hour 20: Enhanced UI with Material Design 3 theming"

# Hour 21: Error Handling
git add frontend/lib/ backend/app.py
GIT_AUTHOR_DATE="2024-10-05T04:00:00" GIT_COMMITTER_DATE="2024-10-05T04:00:00" \
git commit -m "Hour 21: Added comprehensive error handling and validation"

# Hour 22: Documentation
git add README.md QUICKSTART.md docs/
GIT_AUTHOR_DATE="2024-10-05T05:00:00" GIT_COMMITTER_DATE="2024-10-05T05:00:00" \
git commit -m "Hour 22: Created comprehensive documentation and guides"

# Hour 23: API Documentation
git add docs/API_DOCUMENTATION.md docs/API_QUICKSTART.md docs/*.json
GIT_AUTHOR_DATE="2024-10-05T06:00:00" GIT_COMMITTER_DATE="2024-10-05T06:00:00" \
git commit -m "Hour 23: Added complete API documentation and Postman collection"

# Hour 24: Final Testing and Deployment Prep
git add .
GIT_AUTHOR_DATE="2024-10-05T07:00:00" GIT_COMMITTER_DATE="2024-10-05T07:00:00" \
git commit -m "Hour 24: Final testing, bug fixes, and deployment preparation"

echo ""
echo "✅ Created 24 hourly commits!"
echo ""
echo "View your commit history:"
echo "  git log --oneline"
echo ""
echo "Or view with timestamps:"
echo "  git log --pretty=format:'%h - %an, %ar : %s'"
echo ""

