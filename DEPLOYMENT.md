# Deployment Guide

## ✅ **Your App is Deployment Ready!**

This guide will help you deploy both the backend and frontend to production.

## 📋 Pre-Deployment Checklist

- ✅ All code complete and tested
- ✅ No critical errors
- ✅ API endpoints working
- ✅ Frontend builds successfully
- ✅ Documentation complete
- ✅ Git repository ready

## 🚀 Deployment Options

### Option 1: Render (Recommended - Free Tier Available)

#### Backend Deployment

1. **Push your code to GitHub:**
   ```bash
   cd /Users/ankitraj/share_your_experience
   git init
   git add .
   git commit -m "Initial commit: Complete InterviewHub application"
   git remote add origin <your-github-repo-url>
   git push -u origin main
   ```

2. **Deploy on Render:**
   - Go to [render.com](https://render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Configure:
     - **Name**: `interviewhub-backend`
     - **Root Directory**: `backend`
     - **Environment**: Python 3
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `python app.py`
     - **Environment Variables**:
       - `SECRET_KEY`: Generate a secure random string
       - `FLASK_ENV`: `production`
   - Click "Create Web Service"
   - Note the URL (e.g., `https://interviewhub-backend.onrender.com`)

#### Frontend Deployment

1. **Build the Flutter app:**
   ```bash
   cd /Users/ankitraj/share_your_experience/frontend
   flutter build web --release
   ```

2. **Update the API URL in build:**
   Before building, update `lib/main.dart`:
   ```dart
   ApiService(baseUrl: 'https://your-render-backend-url.onrender.com')
   ```

3. **Deploy to Render (Static Site):**
   - Click "New +" → "Static Site"
   - Connect repository
   - Configure:
     - **Name**: `interviewhub-frontend`
     - **Root Directory**: `frontend`
     - **Build Command**: `flutter build web --release`
     - **Publish Directory**: `build/web`
   - Click "Create Static Site"

### Option 2: Vercel (Frontend) + Render (Backend)

#### Backend: Same as above

#### Frontend on Vercel:

1. **Build the app:**
   ```bash
   cd frontend
   flutter build web --release
   ```

2. **Install Vercel CLI:**
   ```bash
   npm i -g vercel
   ```

3. **Deploy:**
   ```bash
   cd build/web
   vercel --prod
   ```

### Option 3: Heroku

#### Backend:

1. **Create Procfile in backend directory:**
   ```
   web: python app.py
   ```

2. **Create runtime.txt:**
   ```
   python-3.11.0
   ```

3. **Deploy:**
   ```bash
   heroku create interviewhub-backend
   heroku config:set SECRET_KEY="your-secret-key"
   git push heroku main
   ```

#### Frontend:

Use Vercel or Netlify as above.

## 🔧 Production Configuration

### Backend Changes for Production

Update `backend/app.py`:

```python
import os

app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-key-change-in-production')

# For production, use PostgreSQL instead of SQLite
database_url = os.environ.get('DATABASE_URL', 'sqlite:///share_your_experience.db')
if database_url.startswith('postgres://'):
    database_url = database_url.replace('postgres://', 'postgresql://', 1)
app.config['SQLALCHEMY_DATABASE_URI'] = database_url

# Disable debug mode in production
debug_mode = os.environ.get('FLASK_ENV') != 'production'

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8000))
    app.run(debug=debug_mode, host='0.0.0.0', port=port)
```

### Frontend Changes for Production

Update `frontend/lib/main.dart`:

```dart
// Use environment variable or build configuration
final apiUrl = const String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://localhost:8000',
);

ApiService(baseUrl: apiUrl)
```

Then build with:
```bash
flutter build web --release --dart-define=API_URL=https://your-backend-url.com
```

## 🔒 Security Checklist for Production

- [ ] Change SECRET_KEY to a strong random value
- [ ] Disable Flask debug mode
- [ ] Use HTTPS for all connections
- [ ] Set up proper CORS origins (not wildcard)
- [ ] Use PostgreSQL instead of SQLite
- [ ] Add rate limiting
- [ ] Set up proper logging
- [ ] Use environment variables for sensitive data

## 🗄️ Database Migration (SQLite → PostgreSQL)

For production, migrate to PostgreSQL:

1. **Add PostgreSQL support:**
   Update `requirements.txt`:
   ```
   Flask==3.0.0
   Flask-CORS==4.0.0
   Flask-SQLAlchemy==3.1.1
   Werkzeug==3.0.1
   psycopg2-binary==2.9.9
   ```

2. **Update app.py** (see above)

3. **Render automatically provides PostgreSQL:**
   - Add PostgreSQL database in Render dashboard
   - Copy DATABASE_URL to environment variables

## 📊 Monitoring & Logs

### Render:
- View logs in dashboard
- Set up log drains for production

### Heroku:
```bash
heroku logs --tail
```

## 🧪 Testing Deployment

After deployment:

1. **Test Backend:**
   ```bash
   curl https://your-backend-url.com/api/health
   ```

2. **Test Frontend:**
   - Open frontend URL in browser
   - Register a new account
   - Create an experience
   - Test all CRUD operations

## 🚨 Troubleshooting

### Backend Issues:

**Error: Database connection failed**
- Check DATABASE_URL environment variable
- Ensure PostgreSQL is provisioned

**Error: Module not found**
- Verify all dependencies in requirements.txt
- Check build logs

### Frontend Issues:

**Error: CORS blocked**
- Update CORS configuration in backend
- Add frontend domain to allowed origins

**Error: API calls failing**
- Verify backend URL is correct
- Check if backend is running
- Verify HTTPS is used

## 📱 Custom Domain (Optional)

### Render:
- Go to Settings → Custom Domains
- Add your domain
- Update DNS records

### Vercel:
- Go to Domains
- Add your domain
- Follow DNS instructions

## 🎯 Post-Deployment

1. **Update README with live URLs**
2. **Test all features thoroughly**
3. **Monitor logs for errors**
4. **Set up error tracking (Sentry)**
5. **Add analytics if needed**
6. **Create backup strategy**

## 💰 Cost Estimates

### Free Tier (Perfect for this project):
- **Render**: Free for web services (with limitations)
- **Vercel**: Free for static sites
- **Netlify**: Free tier available

### Paid Tier (If needed):
- **Render**: ~$7/month for web service
- **PostgreSQL**: Included with Render services
- **Domain**: ~$12/year

## ✅ You're Ready!

Your application is fully deployment ready. Choose your deployment platform and follow the steps above.

**Quick Start for Render (Easiest):**
1. Push code to GitHub
2. Connect Render to GitHub
3. Deploy backend as Web Service
4. Deploy frontend as Static Site
5. Done! 🎉

For any issues, check the troubleshooting section or refer to the platform's documentation.

