import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback onTap;

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.onTap,
  }) : super(key: key);

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
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience.jobTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.business,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              experience.companyName,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _getDifficultyColor(experience.difficulty).withAlpha(25),
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                experience.experienceDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.timer,
                    '${experience.applicationTimelineDays} days',
                  ),
                  _buildInfoChip(
                    experience.offerReceived
                        ? Icons.check_circle
                        : Icons.cancel,
                    experience.offerReceived ? 'Offer Received' : 'No Offer',
                    color: experience.offerReceived ? Colors.green : Colors.grey,
                  ),
                  _buildInfoChip(
                    Icons.person,
                    experience.authorUsername,
                  ),
                  _buildInfoChip(
                    Icons.access_time,
                    dateFormat.format(experience.createdAt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color ?? Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color ?? Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

