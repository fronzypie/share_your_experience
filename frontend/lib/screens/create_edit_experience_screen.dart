import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/experience.dart';
import '../services/api_service.dart';

class CreateEditExperienceScreen extends StatefulWidget {
  final Experience? experience;

  const CreateEditExperienceScreen({Key? key, this.experience})
      : super(key: key);

  @override
  State<CreateEditExperienceScreen> createState() =>
      _CreateEditExperienceScreenState();
}

class _CreateEditExperienceScreenState
    extends State<CreateEditExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _difficulty = 'Medium';
  bool _offerReceived = false;
  DateTime? _applicationDate;
  DateTime? _finalDecisionDate;
  bool _isLoading = false;

  bool get isEditing => widget.experience != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final exp = widget.experience!;
    _jobTitleController.text = exp.jobTitle;
    _companyNameController.text = exp.companyName;
    _descriptionController.text = exp.experienceDescription;
    _difficulty = exp.difficulty;
    _offerReceived = exp.offerReceived;
    _applicationDate = exp.applicationDate;
    _finalDecisionDate = exp.finalDecisionDate;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isApplicationDate) async {
    final initialDate = isApplicationDate
        ? (_applicationDate ?? DateTime.now())
        : (_finalDecisionDate ?? _applicationDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isApplicationDate) {
          _applicationDate = picked;
        } else {
          _finalDecisionDate = picked;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_applicationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an application date')),
      );
      return;
    }

    if (_finalDecisionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a final decision date')),
      );
      return;
    }

    if (_finalDecisionDate!.isBefore(_applicationDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Final decision date cannot be before application date'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = context.read<ApiService>();
      final data = {
        'job_title': _jobTitleController.text.trim(),
        'company_name': _companyNameController.text.trim(),
        'experience_description': _descriptionController.text.trim(),
        'difficulty': _difficulty,
        'offer_received': _offerReceived,
        'application_date': _applicationDate!.toIso8601String().split('T')[0],
        'final_decision_date':
            _finalDecisionDate!.toIso8601String().split('T')[0],
      };

      if (isEditing) {
        await apiService.updateExperience(widget.experience!.id, data);
      } else {
        await apiService.createExperience(data);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate refresh needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Experience updated successfully'
                  : 'Experience created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Experience' : 'Share Your Experience'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _jobTitleController,
                          decoration: const InputDecoration(
                            labelText: 'Job Title *',
                            hintText: 'e.g., Software Engineer',
                            prefixIcon: Icon(Icons.work),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a job title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _companyNameController,
                          decoration: const InputDecoration(
                            labelText: 'Company Name *',
                            hintText: 'e.g., Google',
                            prefixIcon: Icon(Icons.business),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a company name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _difficulty,
                          decoration: const InputDecoration(
                            labelText: 'Interview Difficulty *',
                            prefixIcon: Icon(Icons.trending_up),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Easy',
                              child: Text('Easy'),
                            ),
                            DropdownMenuItem(
                              value: 'Medium',
                              child: Text('Medium'),
                            ),
                            DropdownMenuItem(
                              value: 'Hard',
                              child: Text('Hard'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _difficulty = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Did you receive an offer?'),
                          value: _offerReceived,
                          onChanged: (value) {
                            setState(() {
                              _offerReceived = value;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Experience Description',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Your Interview Experience *',
                            hintText:
                                'Share your interview experience, rounds, questions, tips, etc.',
                            alignLabelWithHint: true,
                          ),
                          maxLines: 8,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please describe your experience';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timeline',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Application Date *'),
                          subtitle: Text(
                            _applicationDate != null
                                ? dateFormat.format(_applicationDate!)
                                : 'Select date',
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _selectDate(context, true),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.event_available),
                          title: const Text('Final Decision Date *'),
                          subtitle: Text(
                            _finalDecisionDate != null
                                ? dateFormat.format(_finalDecisionDate!)
                                : 'Select date',
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _selectDate(context, false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        if (_applicationDate != null && _finalDecisionDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.timer, color: Colors.blue[700]),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Application Timeline: ${_finalDecisionDate!.difference(_applicationDate!).inDays} days',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Cancel'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(isEditing ? 'Update' : 'Submit'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

