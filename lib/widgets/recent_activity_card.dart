import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildActivityItem(
            'New project "Mobile App Redesign" created',
            '2 hours ago',
            Icons.folder_outlined,
            AppTheme.primaryColor,
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'Task "UI Design" marked as completed',
            '4 hours ago',
            Icons.check_circle_outline,
            AppTheme.successColor,
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'New team member added to "Backend API"',
            '6 hours ago',
            Icons.person_add_outlined,
            AppTheme.primaryColor,
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'Comment added to "Database Migration"',
            '1 day ago',
            Icons.comment_outlined,
            AppTheme.warningColor,
          ),
          const Divider(height: 1),
          _buildActivityItem(
            'Project "Security Audit" completed',
            '2 days ago',
            Icons.security_outlined,
            AppTheme.successColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        time,
        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
      ),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textHint),
      onTap: () {
        // Navigate to activity detail
      },
    );
  }
}
