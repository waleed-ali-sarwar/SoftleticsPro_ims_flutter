import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/project_model.dart';
import '../utils/app_theme.dart';

class ProjectOverviewCard extends StatelessWidget {
  final List<Project> projects;

  const ProjectOverviewCard({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final pendingProjects = projects.where((p) => p.status == 'pending').length;
    final inProgressProjects = projects
        .where((p) => p.status == 'in_progress')
        .length;
    final completedProjects = projects
        .where((p) => p.status == 'completed')
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: AppTheme.warningColor,
                      value: pendingProjects.toDouble(),
                      title: 'Pending\n$pendingProjects%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: AppTheme.primaryColor,
                      value: inProgressProjects.toDouble(),
                      title: 'In Progress\n$inProgressProjects%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: AppTheme.successColor,
                      value: completedProjects.toDouble(),
                      title: 'Completed\n$completedProjects%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
