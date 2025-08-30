import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/admin_dashboard.dart';
import 'screens/dashboard/pm_dashboard.dart';
import 'screens/dashboard/employee_dashboard.dart';
import 'providers/auth_provider.dart';
import 'providers/project_provider.dart';
import 'providers/task_provider.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const SoftleticsProApp());
}

class SoftleticsProApp extends StatelessWidget {
  const SoftleticsProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'SoftleticsPro IMS',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          switch (authProvider.userRole) {
            case 'admin':
              return const AdminDashboard();
            case 'project_manager':
              return const PMDashboard();
            case 'employee':
              return const EmployeeDashboard();
            default:
              return const LoginScreen();
          }
        }
        return const LoginScreen();
      },
    );
  }
}
