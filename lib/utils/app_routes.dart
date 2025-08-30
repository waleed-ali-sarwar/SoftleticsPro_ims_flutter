import 'package:flutter/material.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String adminDashboard = '/admin-dashboard';
  static const String pmDashboard = '/pm-dashboard';
  static const String employeeDashboard = '/employee-dashboard';
  static const String projects = '/projects';
  static const String projectDetails = '/project-details';
  static const String tasks = '/tasks';
  static const String taskDetails = '/task-details';
  static const String reports = '/reports';
  static const String users = '/users';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => Container(), // LoginScreen will be imported later
        );
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => Container(), // AdminDashboard will be imported later
        );
      case pmDashboard:
        return MaterialPageRoute(
          builder: (_) => Container(), // PMDashboard will be imported later
        );
      case employeeDashboard:
        return MaterialPageRoute(
          builder: (_) =>
              Container(), // EmployeeDashboard will be imported later
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
