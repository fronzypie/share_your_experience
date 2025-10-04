import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/experience.dart';
import '../widgets/experience_card.dart';
import 'create_edit_experience_screen.dart';
import 'experience_detail_screen.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({Key? key}) : super(key: key);

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  List<Experience> _experiences = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNext = false;
  bool _hasPrev = false;
  
  // Filter and search state
  String? _filterDifficulty;
  String _sortBy = 'date_desc';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExperiences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = context.read<ApiService>();
      final response = await apiService.getExperiences(
        page: _currentPage,
        difficulty: _filterDifficulty,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        sortBy: _sortBy,
      );

      setState(() {
        _experiences = (response['experiences'] as List)
            .map((json) => Experience.fromJson(json))
            .toList();
        _totalPages = response['pages'] as int;
        _hasNext = response['has_next'] as bool;
        _hasPrev = response['has_prev'] as bool;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading experiences: $e')),
        );
      }
    }
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _currentPage = 1;
    });
    _loadExperiences();
  }

  void _onFilterChange(String? difficulty) {
    setState(() {
      _filterDifficulty = difficulty;
      _currentPage = 1;
    });
    _loadExperiences();
  }

  void _onSortChange(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      _currentPage = 1;
    });
    _loadExperiences();
  }

  void _nextPage() {
    if (_hasNext) {
      setState(() {
        _currentPage++;
      });
      _loadExperiences();
    }
  }

  void _previousPage() {
    if (_hasPrev) {
      setState(() {
        _currentPage--;
      });
      _loadExperiences();
    }
  }

  Future<void> _handleLogout() async {
    final authService = context.read<AuthService>();
    await authService.logout();
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateEditExperienceScreen(),
      ),
    );

    if (result == true) {
      _loadExperiences();
    }
  }

  Future<void> _navigateToDetail(Experience experience) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExperienceDetailScreen(experience: experience),
      ),
    );

    if (result == true) {
      _loadExperiences();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final username = authService.currentUser?.username ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewHub'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Welcome, $username!',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              children: [
                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by job title, company, or description...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _onSearch,
                      child: const Text('Search'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sort and Filter Row
                Row(
                  children: [
                    Expanded(
                      child:                       DropdownButtonFormField<String>(
                        initialValue: _sortBy,
                        decoration: InputDecoration(
                          labelText: 'Sort By',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'date_desc',
                            child: Text('Newest First'),
                          ),
                          DropdownMenuItem(
                            value: 'date_asc',
                            child: Text('Oldest First'),
                          ),
                          DropdownMenuItem(
                            value: 'difficulty',
                            child: Text('By Difficulty'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) _onSortChange(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:                       DropdownButtonFormField<String?>(
                        initialValue: _filterDifficulty,
                        decoration: InputDecoration(
                          labelText: 'Filter by Difficulty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Difficulties'),
                          ),
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
                        onChanged: _onFilterChange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Experience List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _experiences.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No experiences found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _experiences.length,
                        itemBuilder: (context, index) {
                          return ExperienceCard(
                            experience: _experiences[index],
                            onTap: () => _navigateToDetail(_experiences[index]),
                          );
                        },
                      ),
          ),
          
          // Pagination Controls
          if (!_isLoading && _experiences.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _hasPrev ? _previousPage : null,
                    icon: const Icon(Icons.chevron_left),
                    label: const Text('Previous'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Page $_currentPage of $_totalPages',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _hasNext ? _nextPage : null,
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Share Your Experience'),
      ),
    );
  }
}

