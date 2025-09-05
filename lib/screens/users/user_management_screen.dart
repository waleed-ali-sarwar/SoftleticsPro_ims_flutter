import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  // Mock user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'John Smith',
      'email': 'john.smith@softleticspro.com',
      'role': 'admin',
      'status': 'active',
      'department': 'Management',
      'joinDate': DateTime(2023, 1, 15),
      'avatar': null,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'email': 'sarah.johnson@softleticspro.com',
      'role': 'project_manager',
      'status': 'active',
      'department': 'Development',
      'joinDate': DateTime(2023, 3, 10),
      'avatar': null,
    },
    {
      'id': '3',
      'name': 'Mike Wilson',
      'email': 'mike.wilson@softleticspro.com',
      'role': 'employee',
      'status': 'active',
      'department': 'Development',
      'joinDate': DateTime(2023, 5, 20),
      'avatar': null,
    },
    {
      'id': '4',
      'name': 'Lisa Davis',
      'email': 'lisa.davis@softleticspro.com',
      'role': 'employee',
      'status': 'inactive',
      'department': 'Design',
      'joinDate': DateTime(2023, 2, 28),
      'avatar': null,
    },
    {
      'id': '5',
      'name': 'Tom Brown',
      'email': 'tom.brown@softleticspro.com',
      'role': 'employee',
      'status': 'active',
      'department': 'QA',
      'joinDate': DateTime(2023, 4, 12),
      'avatar': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Admins', 'admin'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Project Managers', 'project_manager'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Employees', 'employee'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Active', 'active'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Inactive', 'inactive'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: Builder(
              builder: (context) {
                List<Map<String, dynamic>> filteredUsers = _users;

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  filteredUsers = filteredUsers
                      .where(
                        (user) =>
                            user['name'].toString().toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            user['email'].toString().toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                      )
                      .toList();
                }

                // Apply role/status filter
                switch (_selectedFilter) {
                  case 'admin':
                  case 'project_manager':
                  case 'employee':
                    filteredUsers = filteredUsers
                        .where((user) => user['role'] == _selectedFilter)
                        .toList();
                    break;
                  case 'active':
                  case 'inactive':
                    filteredUsers = filteredUsers
                        .where((user) => user['status'] == _selectedFilter)
                        .toList();
                    break;
                }

                if (filteredUsers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outlined,
                          size: 64,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty || _selectedFilter != 'all'
                              ? 'No users found'
                              : 'No users registered',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty || _selectedFilter != 'all'
                              ? 'Try adjusting your filters'
                              : 'Add users to get started',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textHint),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return _buildUserCard(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showUserDetails(user),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  user['name']
                      .toString()
                      .split(' ')
                      .map((n) => n[0])
                      .take(2)
                      .join()
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user['name'],
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: user['status'] == 'active'
                                ? AppTheme.successColor.withOpacity(0.1)
                                : AppTheme.textHint.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['status'].toString().toUpperCase(),
                            style: TextStyle(
                              color: user['status'] == 'active'
                                  ? AppTheme.successColor
                                  : AppTheme.textHint,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user['role']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getRoleDisplayName(user['role']),
                            style: TextStyle(
                              color: _getRoleColor(user['role']),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.business_outlined,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user['department'],
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Button
              PopupMenuButton<String>(
                onSelected: (action) => _handleUserAction(action, user),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: ListTile(
                      leading: Icon(Icons.visibility_outlined),
                      title: Text('View Details'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit User'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (user['status'] == 'active')
                    const PopupMenuItem(
                      value: 'deactivate',
                      child: ListTile(
                        leading: Icon(Icons.block_outlined),
                        title: Text('Deactivate'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  else
                    const PopupMenuItem(
                      value: 'activate',
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Activate'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text(
                        'Delete User',
                        style: TextStyle(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                child: Icon(Icons.more_vert, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppTheme.errorColor;
      case 'project_manager':
        return AppTheme.primaryColor;
      case 'employee':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Administrator';
      case 'project_manager':
        return 'Project Manager';
      case 'employee':
        return 'Employee';
      default:
        return role;
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        user['name']
                            .toString()
                            .split(' ')
                            .map((n) => n[0])
                            .take(2)
                            .join()
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            user['email'],
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Status and Role
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: user['status'] == 'active'
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.textHint.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        user['status'].toString().toUpperCase(),
                        style: TextStyle(
                          color: user['status'] == 'active'
                              ? AppTheme.successColor
                              : AppTheme.textHint,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user['role']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getRoleDisplayName(user['role']),
                        style: TextStyle(
                          color: _getRoleColor(user['role']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // User Details
                _buildDetailRow('Department', user['department']),
                _buildDetailRow(
                  'Join Date',
                  '${user['joinDate'].day}/${user['joinDate'].month}/${user['joinDate'].year}',
                ),
                _buildDetailRow('User ID', user['id']),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditUserDialog(user);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit User'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // Show user projects/tasks
                        },
                        icon: const Icon(Icons.assignment),
                        label: const Text('View Tasks'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: Theme.of(context).textTheme.titleSmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'view':
        _showUserDetails(user);
        break;
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'activate':
      case 'deactivate':
        _showStatusChangeDialog(user, action);
        break;
      case 'delete':
        _showDeleteConfirmDialog(user);
        break;
    }
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: const Text(
          'User creation dialog would be implemented here with form fields for name, email, role, department, etc.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${user['name']}'),
        content: const Text(
          'User editing dialog would be implemented here with form fields pre-filled with current user data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(Map<String, dynamic> user, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${action == 'activate' ? 'Activate' : 'Deactivate'} User'),
        // ignore: unnecessary_brace_in_string_interps
        content: Text('Are you sure you want to ${action} ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update user status
              setState(() {
                user['status'] = action == 'activate' ? 'active' : 'inactive';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${user['name']} has been ${action}d successfully',
                  ),
                ),
              );
            },
            child: Text(action == 'activate' ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${user['name']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete user
              setState(() {
                _users.remove(user);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} has been deleted'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
