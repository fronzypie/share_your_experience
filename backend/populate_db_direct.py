#!/usr/bin/env python3
"""
Script to populate the database directly with sample interview experiences
"""
from app import app, db, User, Experience
from werkzeug.security import generate_password_hash
from datetime import datetime

# Sample data
USERS_DATA = [
    {"username": "sarah_tech", "password": "password123"},
    {"username": "john_dev", "password": "password123"},
    {"username": "alex_engineer", "password": "password123"},
    {"username": "emily_coder", "password": "password123"},
    {"username": "mike_swe", "password": "password123"},
]

EXPERIENCES_DATA = [
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

def populate_database():
    with app.app_context():
        print("🚀 Starting database population...\n")
        
        # Create users
        print("👥 Creating users...")
        users_dict = {}
        
        for user_data in USERS_DATA:
            # Check if user already exists
            existing_user = User.query.filter_by(username=user_data['username']).first()
            if existing_user:
                print(f"ℹ️  User {user_data['username']} already exists")
                users_dict[user_data['username']] = existing_user
            else:
                user = User(username=user_data['username'])
                user.set_password(user_data['password'])
                db.session.add(user)
                users_dict[user_data['username']] = user
                print(f"✅ Created user: {user_data['username']}")
        
        # Commit users
        db.session.commit()
        
        # Create experiences
        print(f"\n📝 Creating {len(EXPERIENCES_DATA)} experiences...")
        success_count = 0
        
        for exp_data in EXPERIENCES_DATA:
            username = exp_data['username']
            user = users_dict.get(username)
            
            if not user:
                print(f"   ⚠️  User {username} not found")
                continue
            
            # Parse dates
            app_date = datetime.strptime(exp_data['application_date'], '%Y-%m-%d').date()
            decision_date = datetime.strptime(exp_data['final_decision_date'], '%Y-%m-%d').date()
            
            experience = Experience(
                job_title=exp_data['job_title'],
                company_name=exp_data['company_name'],
                difficulty=exp_data['difficulty'],
                offer_received=exp_data['offer_received'],
                experience_description=exp_data['experience_description'],
                application_date=app_date,
                final_decision_date=decision_date,
                user_id=user.id
            )
            
            db.session.add(experience)
            success_count += 1
            print(f"   ✅ {exp_data['job_title']} at {exp_data['company_name']} (by {username})")
        
        # Commit all experiences
        db.session.commit()
        
        print(f"\n✅ Successfully created {success_count} experiences!")
        print(f"\n🎉 Database populated! Visit your app to see the data:")
        print(f"   https://darling-axolotl-ce4cbd.netlify.app")
        print(f"\n📊 Summary:")
        print(f"   - Total users: {len(users_dict)}")
        print(f"   - Total experiences: {success_count}")
        print(f"   - Companies: Google, Meta, Amazon, Microsoft, Apple, Netflix, Shopify, Uber, Airbnb, Spotify, Tesla, Twitter")

if __name__ == "__main__":
    populate_database()

