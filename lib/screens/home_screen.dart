// home_screen.dart
import 'package:flutter/material.dart';
import 'package:todo/screens/login_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/bg_office.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                          color: isDarkMode ? Colors.yellow : Colors.white,
                        ),
                        onPressed: onToggleTheme,
                      ),
                    ],
                  ),
                ),
                // Main Content
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App Logo/Icon
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Colors.white,
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(delay: 200.ms),
                          const SizedBox(height: 24),
                          // Title
                          const Text(
                            'Organize Your Day',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 16),
                          // Subtitle
                          const Text(
                            'Create, manage and track your tasks effortlessly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 40),
                          // Get Started Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              backgroundColor: Colors.indigoAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                    isDarkMode: isDarkMode,
                                    onToggleTheme: onToggleTheme,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 800.ms)
                              .scale(delay: 1000.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
