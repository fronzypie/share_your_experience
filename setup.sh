#!/bin/bash

# Setup script for Share Your Experience application
echo "🚀 Setting up Share Your Experience - InterviewHub"
echo "=================================================="

# Setup Backend
echo ""
echo "📦 Setting up Backend..."
cd backend

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

echo "✅ Backend setup complete!"

# Setup Frontend
echo ""
echo "📱 Setting up Frontend..."
cd ../frontend

# Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

echo "✅ Frontend setup complete!"

# Return to root
cd ..

echo ""
echo "=================================================="
echo "✨ Setup Complete! ✨"
echo ""
echo "To run the application:"
echo ""
echo "Terminal 1 (Backend):"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  python app.py"
echo ""
echo "Terminal 2 (Frontend):"
echo "  cd frontend"
echo "  flutter run -d chrome"
echo ""
echo "=================================================="

