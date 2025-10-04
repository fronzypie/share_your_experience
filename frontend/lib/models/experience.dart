class Experience {
  final int id;
  final String jobTitle;
  final String companyName;
  final String experienceDescription;
  final String difficulty;
  final bool offerReceived;
  final DateTime applicationDate;
  final DateTime finalDecisionDate;
  final int applicationTimelineDays;
  final int userId;
  final String authorUsername;
  final DateTime createdAt;

  Experience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.experienceDescription,
    required this.difficulty,
    required this.offerReceived,
    required this.applicationDate,
    required this.finalDecisionDate,
    required this.applicationTimelineDays,
    required this.userId,
    required this.authorUsername,
    required this.createdAt,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as int,
      jobTitle: json['job_title'] as String,
      companyName: json['company_name'] as String,
      experienceDescription: json['experience_description'] as String,
      difficulty: json['difficulty'] as String,
      offerReceived: json['offer_received'] as bool,
      applicationDate: DateTime.parse(json['application_date'] as String),
      finalDecisionDate: DateTime.parse(json['final_decision_date'] as String),
      applicationTimelineDays: json['application_timeline_days'] as int,
      userId: json['user_id'] as int,
      authorUsername: json['author_username'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_title': jobTitle,
      'company_name': companyName,
      'experience_description': experienceDescription,
      'difficulty': difficulty,
      'offer_received': offerReceived,
      'application_date': applicationDate.toIso8601String().split('T')[0],
      'final_decision_date': finalDecisionDate.toIso8601String().split('T')[0],
    };
  }
}

