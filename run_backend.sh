#!/bin/bash

# Script to run the Flask backend
echo "🔧 Starting Flask Backend..."

cd backend

# Activate virtual environment
if [ -d "venv" ]; then
    source venv/bin/activate
else
    echo "❌ Virtual environment not found!"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Check if dependencies are installed
if ! python -c "import flask" 2>/dev/null; then
    echo "❌ Dependencies not installed!"
    echo "Please run ./setup.sh first"
    exit 1
fi

# Run the Flask app
echo "✅ Starting server on http://localhost:5000"
python app.py

