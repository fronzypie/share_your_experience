#!/usr/bin/env python3
"""
Script to populate the database with sample interview experiences
"""
import requests
import json
from datetime import datetime, timedelta

# Backend API URL
API_BASE = "https://interviewhub-backend.onrender.com/api"

# Sample users to create
USERS = [
    {"username": "sarah_tech", "password": "password123"},
    {"username": "john_dev", "password": "password123"},
    {"username": "alex_engineer", "password": "password123"},
    {"username": "emily_coder", "password": "password123"},
    {"username": "mike_swe", "password": "password123"},
]

# Sample experiences
EXPERIENCES = [
    {
        "username": "sarah_tech",
        "job_title": "Software Engineer",
        "company_name": "Google",
        "difficulty": "Hard",
        "offer_received": True,
        "experience_description": "Had 5 rounds of interviews. Started with phone screen covering data structures. Then 4 on-site rounds: 2 coding (LeetCode hard problems), 1 system design (design YouTube), and 1 behavioral. Very challenging but fair. Interviewers were friendly and gave hints when stuck.",
        "application_date": "2025-08-15",
        "final_decision_date": "2025-09-20"
    },
    {
        "username": "john_dev",
        "job_title": "Frontend Developer",
        "company_name": "Meta",
        "difficulty": "Medium",
        "offer_received": True,
        "experience_description": "Great interview experience! Started with a recruiter call, then technical phone screen on React and JavaScript fundamentals. Two virtual on-sites: one focused on building a React component from scratch, another on system design for a social media feed. Got offer after 2 weeks!",
        "application_date": "2025-07-10",
        "final_decision_date": "2025-08-05"
    },
    {
        "username": "alex_engineer",
        "job_title": "Backend Engineer",
        "company_name": "Amazon",
        "difficulty": "Medium",
        "offer_received": False,
        "experience_description": "Applied through referral. Had 3 rounds focused on Amazon leadership principles. Technical rounds were moderate - mostly medium LeetCode problems. One system design round about designing a distributed cache. Didn't get offer but learned a lot!",
        "application_date": "2025-06-20",
        "final_decision_date": "2025-07-15"
    },
    {
        "username": "emily_coder",
        "job_title": "Full Stack Developer",
        "company_name": "Microsoft",
        "difficulty": "Medium",
        "offer_received": True,
        "experience_description": "Very smooth process. Phone screen with easy-medium coding questions. Then 4 on-site rounds: 2 coding, 1 system design, 1 behavioral. Questions were fair and interviewers were supportive. They really care about problem-solving approach more than perfect solution. Great experience overall!",
        "application_date": "2025-09-01",
        "final_decision_date": "2025-09-28"
    },
    {
        "username": "mike_swe",
        "job_title": "Software Engineer Intern",
        "company_name": "Apple",
        "difficulty": "Easy",
        "offer_received": True,
        "experience_description": "Applied for internship. One phone screen with basic coding questions and one video interview with team. Questions focused on fundamentals - arrays, strings, basic algorithms. Very welcoming environment for interns. Got offer within 2 weeks!",
        "application_date": "2025-05-10",
        "final_decision_date": "2025-05-25"
    },
    {
        "username": "sarah_tech",
        "job_title": "Senior Software Engineer",
        "company_name": "Netflix",
        "difficulty": "Hard",
        "offer_received": False,
        "experience_description": "Extremely challenging. Phone screen was already hard. On-site had complex system design questions about video streaming at scale. Coding rounds were all LeetCode hard level. High bar but very respectful process. Didn't make it past on-site but great learning experience.",
        "application_date": "2025-07-01",
        "final_decision_date": "2025-08-10"
    },
    {
        "username": "john_dev",
        "job_title": "JavaScript Developer",
        "company_name": "Shopify",
        "difficulty": "Easy",
        "offer_received": True,
        "experience_description": "Very positive experience! One technical phone screen with practical JavaScript questions. Then one pair programming session building a small e-commerce feature. They value collaboration and communication skills. Offer came within a week. Highly recommend!",
        "application_date": "2025-08-20",
        "final_decision_date": "2025-09-05"
    },
    {
        "username": "alex_engineer",
        "job_title": "DevOps Engineer",
        "company_name": "Uber",
        "difficulty": "Medium",
        "offer_received": True,
        "experience_description": "Focus on system design and infrastructure. Phone screen covered Docker, Kubernetes, and CI/CD concepts. On-site had 3 rounds: infrastructure design, coding (medium problems), and behavioral. Great team and interesting problems to solve!",
        "application_date": "2025-09-10",
        "final_decision_date": "2025-10-01"
    },
    {
        "username": "emily_coder",
        "job_title": "Software Engineer",
        "company_name": "Airbnb",
        "difficulty": "Hard",
        "offer_received": True,
        "experience_description": "Challenging but well-structured. Started with coding phone screen. Then 4 rounds on-site: 2 coding (hard), 1 system design (design booking system), 1 cross-functional collaboration. They really care about culture fit and product thinking. Tough but worth it!",
        "application_date": "2025-06-15",
        "final_decision_date": "2025-07-30"
    },
    {
        "username": "mike_swe",
        "job_title": "Junior Developer",
        "company_name": "Spotify",
        "difficulty": "Easy",
        "offer_received": True,
        "experience_description": "Great experience for entry-level! One phone screen with easy coding questions about arrays and hashmaps. Then one technical video call building a simple music playlist feature. Very friendly interviewers who helped me when I was nervous. Perfect for beginners!",
        "application_date": "2025-08-01",
        "final_decision_date": "2025-08-20"
    },
    {
        "username": "sarah_tech",
        "job_title": "Machine Learning Engineer",
        "company_name": "Tesla",
        "difficulty": "Hard",
        "offer_received": False,
        "experience_description": "Very technical and intense. Phone screen covered ML fundamentals and coding. On-site had ML system design, coding with focus on optimization, and deep dive into past ML projects. Extremely high technical bar. Didn't get offer but amazing learning opportunity.",
        "application_date": "2025-05-20",
        "final_decision_date": "2025-06-25"
    },
    {
        "username": "john_dev",
        "job_title": "React Developer",
        "company_name": "Twitter",
        "difficulty": "Medium",
        "offer_received": True,
        "experience_description": "Focused heavily on frontend skills. Phone screen with React hooks and state management questions. On-site had live coding building a Twitter-like component, performance optimization discussion, and behavioral round. Fast-paced interview process. Got offer in 2 weeks!",
        "application_date": "2025-07-15",
        "final_decision_date": "2025-08-01"
    },
]

def create_user_and_login(user):
    """Register user and login to get session"""
    session = requests.Session()
    
    # Try to register (might already exist)
    try:
        register_response = session.post(
            f"{API_BASE}/auth/register",
            json=user,
            timeout=30
        )
        print(f"✅ Registered user: {user['username']}")
    except Exception as e:
        print(f"ℹ️  User {user['username']} might already exist")
    
    # Login
    login_response = session.post(
        f"{API_BASE}/auth/login",
        json=user,
        timeout=30
    )
    
    if login_response.status_code == 200:
        print(f"✅ Logged in as: {user['username']}")
        return session
    else:
        print(f"❌ Failed to login: {user['username']}")
        return None

def create_experience(session, experience_data):
    """Create an experience"""
    try:
        response = session.post(
            f"{API_BASE}/experiences",
            json=experience_data,
            timeout=30
        )
        
        if response.status_code == 201:
            print(f"   ✅ Created: {experience_data['job_title']} at {experience_data['company_name']}")
            return True
        else:
            print(f"   ❌ Failed to create experience: {response.status_code}")
            return False
    except Exception as e:
        print(f"   ❌ Error creating experience: {str(e)}")
        return False

def main():
    print("🚀 Starting database population...\n")
    
    # Create a dictionary to store sessions
    sessions = {}
    
    # Create and login all users
    print("👥 Creating users...")
    for user in USERS:
        session = create_user_and_login(user)
        if session:
            sessions[user['username']] = session
    
    print(f"\n📝 Creating {len(EXPERIENCES)} experiences...")
    
    # Create experiences
    success_count = 0
    for exp in EXPERIENCES:
        username = exp.pop('username')  # Remove username from experience data
        
        if username in sessions:
            if create_experience(sessions[username], exp):
                success_count += 1
        else:
            print(f"   ⚠️  No session for {username}")
    
    print(f"\n✅ Successfully created {success_count}/{len(EXPERIENCES)} experiences!")
    print(f"\n🎉 Database populated! Visit your app to see the data:")
    print(f"   https://darling-axolotl-ce4cbd.netlify.app")

if __name__ == "__main__":
    main()

