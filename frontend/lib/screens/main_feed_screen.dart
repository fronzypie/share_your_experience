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
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'date_desc';

  // --- NEW STATE VARIABLES for Company Filter ---
  String? _selectedCompany;
  List<String> _companyNames = [];
  // ---

  @override
  void initState() {
    super.initState();
    // Load both experiences and company names when the screen initializes
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- NEW METHOD: Loads all initial data ---
  Future<void> _loadInitialData() async {
    // Fetch experiences and company names in parallel for better performance
    await Future.wait([
      _loadExperiences(),
      _loadCompanyNames(),
    ]);
  }

  // --- NEW METHOD: Fetches the list of company names from the API ---
  Future<void> _loadCompanyNames() async {
    try {
      final apiService = context.read<ApiService>();
      final companies = await apiService.getCompanyNames();
      if (mounted) {
        setState(() {
          // Add a default option to show all companies and set it as the initial value
          _companyNames = ['All Companies', ...companies];
          _selectedCompany = 'All Companies';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading company names: $e')),
        );
      }
    }
  }

  // --- UPDATED METHOD: Now includes the company filter ---
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
        // Pass the selected company to the API call.
        // If 'All Companies' is selected, pass null to fetch all.
        company: (_selectedCompany == 'All Companies') ? null : _selectedCompany,
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

  // --- NEW HANDLER for when the company dropdown value changes ---
  void _onCompanyChange(String? company) {
    setState(() {
      _selectedCompany = company;
      _currentPage = 1; // Reset to the first page when filter changes
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
                // Search Bar Row (no changes needed)
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
                // Sort and Difficulty Row (no changes needed)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        // ... items and onChanged for Sort By
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _filterDifficulty,
                        // ... items and onChanged for Filter by Difficulty
                      ),
                    ),
                  ],
                ),
                
                // --- ADDED WIDGET: Company Filter Dropdown ---
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: _selectedCompany,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Filter by Company',
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
                  items: _companyNames.map((String company) {
                    return DropdownMenuItem<String>(
                      value: company,
                      child: Text(company, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: _onCompanyChange,
                ),
                // ---
              ],
            ),
          ),
          
          // Experience List (no changes needed)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _experiences.isEmpty
                    ? Center(/* ... No experiences found UI ... */)
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
          
          // Pagination Controls (no changes needed)
          if (!_isLoading && _experiences.isNotEmpty)
            Container(
              // ... pagination UI ...
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