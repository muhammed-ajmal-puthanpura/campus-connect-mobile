/// Splash Screen
/// Initial loading screen that checks authentication status
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Initialize authentication
    await authProvider.init();
    
    // Wait a bit for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Navigate based on authentication status
    if (authProvider.isAuthenticated) {
      _navigateToDashboard(authProvider.userRole);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateToDashboard(String? role) {
    if (role == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final normalizedRole = role.toLowerCase().trim();
    
    if (normalizedRole == 'student') {
      Navigator.pushReplacementNamed(context, '/student-dashboard');
    } else if (normalizedRole == 'event organizer' || normalizedRole == 'organizer') {
      Navigator.pushReplacementNamed(context, '/organizer-dashboard');
    } else if (normalizedRole == 'hod') {
      Navigator.pushReplacementNamed(context, '/hod-dashboard');
    } else if (normalizedRole == 'principal') {
      Navigator.pushReplacementNamed(context, '/principal-dashboard');
    } else if (normalizedRole == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.event_available,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            // App Name
            const Text(
              'Campus Connect',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Event Management System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
