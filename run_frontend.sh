#!/bin/bash

# Script to run the Flutter Web frontend
echo "🌐 Starting Flutter Web Frontend..."

cd frontend

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed!"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d ".dart_tool" ]; then
    echo "📦 Installing dependencies..."
    flutter pub get
fi

# Run the Flutter web app
echo "✅ Starting Flutter web app..."
flutter run -d chrome

