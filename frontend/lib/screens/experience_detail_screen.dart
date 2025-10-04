import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/experience.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'create_edit_experience_screen.dart';

class ExperienceDetailScreen extends StatelessWidget {
  final Experience experience;

  const ExperienceDetailScreen({Key? key, required this.experience})
      : super(key: key);

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Experience'),
        content: const Text(
          'Are you sure you want to delete this experience? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final apiService = context.read<ApiService>();
        await apiService.deleteExperience(experience.id);
        
        if (context.mounted) {
          Navigator.of(context).pop(true); // Return true to indicate refresh needed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Experience deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting experience: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateEditExperienceScreen(experience: experience),
      ),
    );

    if (result == true && context.mounted) {
      Navigator.of(context).pop(true); // Return true to refresh the list
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final currentUserId = authService.currentUser?.id;
    final isAuthor = currentUserId == experience.userId;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience Details'),
        actions: isAuthor
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                  onPressed: () => _handleEdit(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: () => _handleDelete(context),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  experience.jobTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.business,
                                        size: 20, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Text(
                                      experience.companyName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(experience.difficulty)
                                  .withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getDifficultyColor(experience.difficulty),
                              ),
                            ),
                            child: Text(
                              experience.difficulty,
                              style: TextStyle(
                                color: _getDifficultyColor(experience.difficulty),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Posted by ${experience.authorUsername}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Spacer(),
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(experience.createdAt),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Experience Description
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interview Experience',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        experience.experienceDescription,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Timeline and Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application Timeline',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Application Date',
                        dateFormat.format(experience.applicationDate),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.event_available,
                        'Final Decision Date',
                        dateFormat.format(experience.finalDecisionDate),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.timer,
                        'Total Days',
                        '${experience.applicationTimelineDays} days',
                        highlight: true,
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        experience.offerReceived
                            ? Icons.check_circle
                            : Icons.cancel,
                        'Offer Received',
                        experience.offerReceived ? 'Yes' : 'No',
                        color: experience.offerReceived
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool highlight = false,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: highlight ? 18 : 16,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

