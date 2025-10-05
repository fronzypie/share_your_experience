# 🚀 Quick Deployment Guide

## ✅ **Prerequisites Done:**
- ✅ Code on GitHub: https://github.com/fronzypie/share_your_experience
- ✅ API URL configured for production
- ✅ Ready to deploy!

---

## **STEP 1: Deploy Backend (5 minutes)**

### **1.1 Go to Render**
- Visit: https://render.com
- Sign up with GitHub (free account)

### **1.2 Create Web Service**
1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repo: `fronzypie/share_your_experience`
3. Fill in these settings:

```
Name: interviewhub-backend
Region: Singapore (or closest to you)
Branch: main
Root Directory: backend
Runtime: Python 3
Build Command: pip install -r requirements.txt
Start Command: python app.py
Instance Type: Free
```

### **1.3 Add Environment Variables**
Click **"Advanced"** → **"Add Environment Variable"**:

| Key | Value |
|-----|-------|
| `SECRET_KEY` | Generate with: `python3 -c "import secrets; print(secrets.token_hex(32))"` |
| `PORT` | `8000` |
| `PYTHON_VERSION` | `3.11.0` |

### **1.4 Deploy**
- Click **"Create Web Service"**
- Wait 3-5 minutes
- Copy your URL: `https://YOUR-APP-NAME.onrender.com`

### **1.5 Test**
```bash
curl https://YOUR-APP-NAME.onrender.com/api/health
```
Should return: `{"status":"healthy"}` ✅

---

## **STEP 2: Deploy Frontend (5 minutes)**

### **2.1 Build Locally with Production URL**

**Replace YOUR-BACKEND-URL with your Render URL from Step 1:**

```bash
cd /Users/ankitraj/share_your_experience/frontend

flutter build web --release \
  --dart-define=API_URL=https://YOUR-BACKEND-URL.onrender.com
```

### **2.2 Deploy to Vercel**

**Option A: Vercel Dashboard (Recommended)**
1. Go to https://vercel.com
2. Sign up with GitHub
3. Click **"Add New..."** → **"Project"**
4. Import: `fronzypie/share_your_experience`
5. Configure:
   ```
   Framework: Other
   Root Directory: frontend
   Build Command: flutter build web --release --dart-define=API_URL=https://YOUR-BACKEND-URL.onrender.com
   Output Directory: build/web
   ```
6. Click **"Deploy"**
7. Get URL: `https://YOUR-APP.vercel.app`

**Option B: Vercel CLI**
```bash
npm i -g vercel

cd /Users/ankitraj/share_your_experience/frontend
flutter build web --release --dart-define=API_URL=https://YOUR-BACKEND-URL.onrender.com
cd build/web
vercel --prod
```

---

## **STEP 3: Update Backend CORS (Important!)**

After getting your Vercel URL, update backend to allow it:

1. Go to Render dashboard
2. Find your backend service
3. Go to **"Environment"** tab
4. Add variable:
   ```
   FRONTEND_URL=https://YOUR-APP.vercel.app
   ```
5. Click **"Save Changes"**
6. Backend will auto-redeploy

---

## **STEP 4: Test Your Deployed App**

1. **Open Frontend URL**: `https://YOUR-APP.vercel.app`
2. **Register** a new account
3. **Create** an experience
4. **Test** all features

---

## **STEP 5: Get Your URLs for Submission**

📝 **For Assignment:**

- **Live Backend**: `https://YOUR-BACKEND.onrender.com`
- **Live Frontend**: `https://YOUR-APP.vercel.app`
- **GitHub Repo**: `https://github.com/fronzypie/share_your_experience`
- **API Health**: `https://YOUR-BACKEND.onrender.com/api/health`

---

## 🎯 **Quick Summary Commands**

```bash
# 1. Generate SECRET_KEY
python3 -c "import secrets; print(secrets.token_hex(32))"

# 2. Build frontend (replace URL)
cd frontend
flutter build web --release \
  --dart-define=API_URL=https://YOUR-BACKEND-URL.onrender.com

# 3. Deploy with Vercel
cd build/web
vercel --prod

# 4. Test backend
curl https://YOUR-BACKEND.onrender.com/api/health

# 5. Test frontend
open https://YOUR-FRONTEND.vercel.app
```

---

## ⚠️ **Important Notes:**

1. **Free Tier Limitations:**
   - Render free tier sleeps after 15 min of inactivity
   - First request may take 30-60 seconds to wake up
   - Perfect for demo/assignment, but not production traffic

2. **Database:**
   - Currently using SQLite (file-based)
   - For production, upgrade to PostgreSQL on Render

3. **CORS:**
   - Make sure to add your Vercel URL to backend CORS settings
   - Without this, frontend can't communicate with backend

---

## 🆘 **Troubleshooting:**

### Backend Issues:

**"Port already in use"**
- Render assigns port automatically, no action needed

**"Build failed"**
- Check `requirements.txt` is in `/backend` folder
- Verify Python version is set

**"502 Bad Gateway"**
- Service is starting (wait 30 seconds)
- Check logs in Render dashboard

### Frontend Issues:

**"API calls failing"**
- Verify backend URL is correct in build command
- Check backend is running: `curl YOUR-BACKEND-URL/api/health`
- Check CORS is configured

**"Build failed"**
- Ensure Flutter is installed on build machine
- For Vercel, use the pre-built files method

---

## ✅ **Deployment Checklist:**

- [ ] Backend deployed to Render
- [ ] Backend health check working
- [ ] SECRET_KEY set
- [ ] Frontend built with correct API_URL
- [ ] Frontend deployed to Vercel
- [ ] Can open frontend in browser
- [ ] Can register new account
- [ ] Can create experience
- [ ] All CRUD operations work
- [ ] URLs saved for submission

---

## 📋 **Submission URLs Template:**

```
Project: InterviewHub - Share Your Experience

Live URLs:
- Frontend: https://YOUR-APP.vercel.app
- Backend API: https://YOUR-BACKEND.onrender.com
- API Health: https://YOUR-BACKEND.onrender.com/api/health

Repository:
- GitHub: https://github.com/fronzypie/share_your_experience

Test Account (for reviewer):
- Username: demo
- Password: demo123
```

---

**Ready to deploy? Follow Step 1!** 🚀

