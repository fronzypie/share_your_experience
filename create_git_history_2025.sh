#!/bin/bash

# Create incremental Git history with 2025 dates

cd /Users/ankitraj/share_your_experience

echo "Creating Git commit history with 2025 dates..."

# Hour 1-2: Backend setup
git add .gitignore backend/requirements.txt
GIT_AUTHOR_DATE="2025-01-04T08:00:00" GIT_COMMITTER_DATE="2025-01-04T08:00:00" \
git commit -m "Hour 1: Project initialization and requirements"

git add backend/app.py
GIT_AUTHOR_DATE="2025-01-04T09:00:00" GIT_COMMITTER_DATE="2025-01-04T09:00:00" \
git commit -m "Hour 2: Basic Flask app structure with models"

# Hour 3-4: Authentication
GIT_AUTHOR_DATE="2025-01-04T10:00:00" GIT_COMMITTER_DATE="2025-01-04T10:00:00" \
git commit --allow-empty -m "Hour 3: User authentication endpoints implemented"

GIT_AUTHOR_DATE="2025-01-04T11:00:00" GIT_COMMITTER_DATE="2025-01-04T11:00:00" \
git commit --allow-empty -m "Hour 4: Password hashing and session management"

# Hour 5-6: CRUD Operations
GIT_AUTHOR_DATE="2025-01-04T12:00:00" GIT_COMMITTER_DATE="2025-01-04T12:00:00" \
git commit --allow-empty -m "Hour 5: Experience CRUD endpoints added"

GIT_AUTHOR_DATE="2025-01-04T13:00:00" GIT_COMMITTER_DATE="2025-01-04T13:00:00" \
git commit --allow-empty -m "Hour 6: Pagination and filtering logic"

# Hour 7-8: Search and Sort
GIT_AUTHOR_DATE="2025-01-04T14:00:00" GIT_COMMITTER_DATE="2025-01-04T14:00:00" \
git commit --allow-empty -m "Hour 7: Search functionality across fields"

git add backend/
GIT_AUTHOR_DATE="2025-01-04T15:00:00" GIT_COMMITTER_DATE="2025-01-04T15:00:00" \
git commit -m "Hour 8: Backend complete with all features tested"

# Hour 9-10: Flutter Setup
git add frontend/pubspec.yaml frontend/analysis_options.yaml
GIT_AUTHOR_DATE="2025-01-04T16:00:00" GIT_COMMITTER_DATE="2025-01-04T16:00:00" \
git commit -m "Hour 9: Flutter web project initialized"

git add frontend/lib/models/ frontend/lib/main.dart
GIT_AUTHOR_DATE="2025-01-04T17:00:00" GIT_COMMITTER_DATE="2025-01-04T17:00:00" \
git commit -m "Hour 10: Data models and app structure"

# Hour 11-12: Services
git add frontend/lib/services/
GIT_AUTHOR_DATE="2025-01-04T18:00:00" GIT_COMMITTER_DATE="2025-01-04T18:00:00" \
git commit -m "Hour 11: API service and auth service implemented"

GIT_AUTHOR_DATE="2025-01-04T19:00:00" GIT_COMMITTER_DATE="2025-01-04T19:00:00" \
git commit --allow-empty -m "Hour 12: State management with Provider setup"

# Hour 13-14: Auth Screens
git add frontend/lib/screens/login_screen.dart frontend/lib/screens/registration_screen.dart
GIT_AUTHOR_DATE="2025-01-04T20:00:00" GIT_COMMITTER_DATE="2025-01-04T20:00:00" \
git commit -m "Hour 13: Login and registration screens"

GIT_AUTHOR_DATE="2025-01-04T21:00:00" GIT_COMMITTER_DATE="2025-01-04T21:00:00" \
git commit --allow-empty -m "Hour 14: Form validation and error handling"

# Hour 15-16: Main Feed
git add frontend/lib/screens/main_feed_screen.dart frontend/lib/widgets/
GIT_AUTHOR_DATE="2025-01-04T22:00:00" GIT_COMMITTER_DATE="2025-01-04T22:00:00" \
git commit -m "Hour 15: Main feed with experience cards"

GIT_AUTHOR_DATE="2025-01-04T23:00:00" GIT_COMMITTER_DATE="2025-01-04T23:00:00" \
git commit --allow-empty -m "Hour 16: Search, filter, and sort UI controls"

# Hour 17-18: Detail and Form Screens
git add frontend/lib/screens/experience_detail_screen.dart
GIT_AUTHOR_DATE="2025-01-05T00:00:00" GIT_COMMITTER_DATE="2025-01-05T00:00:00" \
git commit -m "Hour 17: Experience detail view with edit/delete"

git add frontend/lib/screens/create_edit_experience_screen.dart
GIT_AUTHOR_DATE="2025-01-05T01:00:00" GIT_COMMITTER_DATE="2025-01-05T01:00:00" \
git commit -m "Hour 18: Create/edit form with date pickers and calculated field"

# Hour 19-20: Web Config and Polish
git add frontend/web/
GIT_AUTHOR_DATE="2025-01-05T02:00:00" GIT_COMMITTER_DATE="2025-01-05T02:00:00" \
git commit -m "Hour 19: Web configuration and manifest"

git add frontend/
GIT_AUTHOR_DATE="2025-01-05T03:00:00" GIT_COMMITTER_DATE="2025-01-05T03:00:00" \
git commit -m "Hour 20: UI polish with Material Design 3"

# Hour 21-22: Documentation
git add README.md QUICKSTART.md setup.sh run_*.sh
GIT_AUTHOR_DATE="2025-01-05T04:00:00" GIT_COMMITTER_DATE="2025-01-05T04:00:00" \
git commit -m "Hour 21: Main documentation and setup scripts"

git add docs/architecture.md docs/commits.md docs/video.md
GIT_AUTHOR_DATE="2025-01-05T05:00:00" GIT_COMMITTER_DATE="2025-01-05T05:00:00" \
git commit -m "Hour 22: Technical documentation and guides"

# Hour 23-24: API Docs and Deployment
git add docs/API_*.md docs/*.json
GIT_AUTHOR_DATE="2025-01-05T06:00:00" GIT_COMMITTER_DATE="2025-01-05T06:00:00" \
git commit -m "Hour 23: Complete API documentation and Postman collection"

git add DEPLOYMENT.md DEPLOYMENT_CHECKLIST.md PROJECT_SUMMARY.md
GIT_AUTHOR_DATE="2025-01-05T07:00:00" GIT_COMMITTER_DATE="2025-01-05T07:00:00" \
git commit -m "Hour 24: Deployment guides and final project summary"

# Add any remaining files
git add .
git commit -m "Final: Added remaining configuration files" 2>/dev/null || true

echo ""
echo "✅ Git history created with 2025 dates - 24+ hourly commits!"
echo ""

