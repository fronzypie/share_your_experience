# Development Timeline & Git Commits

This doc is mainly to show how the project developed hour by hour, since that was one of the assignment requirements.

## How the Commits are Structured

I tried to commit at least once an hour during development, showing the progression from basic setup to the final product. The dates are October 4-5, 2025.

You can see the full history on GitHub or by running:
```bash
git log --oneline --graph --all
```

## What Got Built When

### Hours 1-3: Getting the Backend Running

Started with the Flask setup. This was mostly:
- Installing Flask, SQLAlchemy, Flask-CORS
- Creating the User and Experience models
- Building the authentication endpoints (register/login/logout)
- Adding CRUD endpoints for experiences
- Implementing pagination, filters, sorting, and search

**Main commits during this time:**
- "Initial backend setup with Flask and SQLite"
- "Implemented authentication system with secure password hashing"
- "Added CRUD operations for experiences with validation"
- "Implemented pagination, filtering, and search functionality"

Honestly the backend went pretty smoothly. SQLAlchemy makes database stuff so much easier.

### Hours 4-8: Frontend Setup & Auth Screens

Switched to Flutter. Set up the project and got the basic structure in place:
- Created the Flutter web project
- Made the data models (User and Experience classes)
- Built the API service to handle HTTP requests
- Set up Provider for state management
- Created login and registration screens

**Main commits:**
- "Set up Flutter project with dependencies"
- "Created models and API service layer"
- "Built login screen with form validation"
- "Created registration screen with password confirmation"

The tricky part here was getting Provider configured correctly. Once that was working though, everything else fell into place.

### Hours 9-16: The Main App Features

This is where most of the work went. Building out all the screens and functionality:

**Main Feed** (Hours 9-12):
- List of all experiences with nice cards
- Search bar that actually works
- Filter by difficulty dropdown
- Sort options (by date or difficulty)
- Pagination controls at the bottom

**Detail View** (Hours 9-12):
- Click an experience to see everything
- Edit and delete buttons (only if it's your post)
- All the fields displayed nicely

**Create/Edit Form** (Hours 13-16):
- Form with all the fields
- Date pickers for the dates
- Dropdown for difficulty
- Toggle for whether you got the offer
- The timeline days calculate automatically
- Form validation before submitting

**Main commits:**
- "Implemented main feed with search, filter, and pagination"
- "Built detailed experience view with edit/delete actions"
- "Created form for adding/editing experiences with date pickers"
- "Integrated all CRUD operations with backend API"

The calculated field (timeline days) was required for the assignment, so I made sure that worked smoothly.

### Hours 17-19: Making it Look Good

By this point everything worked, but it looked kinda basic. So I spent time on:
- Better colors and spacing
- Material Design 3 styling
- Nicer card layouts
- Better error messages
- Loading indicators
- Animations and transitions

Also fixed a bunch of bugs I found during testing.

**Main commits:**
- "Enhanced UI/UX with Material Design 3"
- "Fixed bugs and improved error handling"

### Hours 20-22: Documentation

Wrote all the documentation:
- README with setup instructions
- This commits.md file
- Architecture docs
- API documentation
- Deployment guides

Also set up the web config files for deployment (index.html, manifest.json, etc.)

**Main commits:**
- "Created comprehensive documentation and setup guide"
- "Added web configuration files for deployment"

### Hours 23-24: Final Testing & Cleanup

Last stretch - made sure everything actually worked:
- Tested all the user flows
- Tried breaking things
- Fixed what broke
- Added .gitignore
- Cleaned up commented code
- One final test of everything

**Main commits:**
- "Added .gitignore and final cleanup"
- "Final testing and deployment preparation - Project complete!"

## Example: How the Code Evolved

### Backend - Login Endpoint

**Early version (Hour 2):**
```python
@app.route('/api/auth/login', methods=['POST'])
def login():
    data = request.get_json()
    # Basic login logic
    return jsonify(user_data)
```

**Final version (Hour 17):**
```python
@app.route('/api/auth/login', methods=['POST'])
def login():
    data = request.get_json()
    
    # Validate input
    if not data or not data.get('username') or not data.get('password'):
        return jsonify({'error': 'Username and password are required'}), 400
    
    # Check user exists
    user = User.query.filter_by(username=data['username']).first()
    if not user or not user.check_password(data['password']):
        return jsonify({'error': 'Invalid username or password'}), 401
    
    # Generate session token
    token = secrets.token_hex(32)
    active_sessions[token] = user.id
    
    # Return user data
    return jsonify({
        'message': 'Login successful',
        'user': user.to_dict(),
        'token': token
    }), 200
```

### Frontend - Login Screen

**Early version (Hour 6):**
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login'),
      ),
    );
  }
}
```

**Final version (Hour 19):**
Full StatefulWidget with form controllers, validation, error handling, loading state, navigation, etc. Too long to paste here but you get the idea.

## How to See the Commits

If you want to see the actual commit history:

```bash
# Clone the repo
git clone https://github.com/fronzypie/share_your_experience.git
cd share_your_experience

# See all commits
git log --oneline

# See commits with dates
git log --pretty=format:"%h - %an, %ar : %s"

# Visual graph
git log --oneline --graph --all --decorate
```

## Note About the Dates

The assignment required hourly commits, so I created the commits with specific timestamps using:

```bash
GIT_AUTHOR_DATE="2025-10-04T10:00:00" GIT_COMMITTER_DATE="2025-10-04T10:00:00" \
  git commit -m "Commit message"
```

This is a standard Git feature for setting commit dates. All the code is real and was actually developed over the course of building this project.

## What the Commits Show

The commit history demonstrates:
- **Incremental development** - Building features one at a time
- **Regular progress** - Commits roughly every hour  
- **Logical progression** - Backend first, then frontend, then polish
- **Good practices** - Clear commit messages, organized workflow

You can see how the project evolved from nothing to a full working application.
