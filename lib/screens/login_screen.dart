import 'package:flutter/material.dart';
import 'package:todo/screens/task_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Simple credentials for demo
  final String _demoUsername = 'demo';
  final String _demoPassword = 'password123';

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        if (_usernameController.text == _demoUsername &&
            _passwordController.text == _demoPassword) {
          _goToDashboard();
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      });
    }
  }

  void _goToDashboard() {
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDashboard(
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? Colors.black87 : Colors.indigo,
        title: const Text('Login'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: widget.isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(height: 30),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: widget.isDarkMode ? Colors.white70 : Colors.grey),
                    labelStyle: TextStyle(color: widget.isDarkMode ? Colors.white70 : Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.isDarkMode ? Colors.white70 : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.isDarkMode ? Colors.white : Colors.indigo),
                    ),
                  ),
                  style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline, color: widget.isDarkMode ? Colors.white70 : Colors.grey),
                    labelStyle: TextStyle(color: widget.isDarkMode ? Colors.white70 : Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.isDarkMode ? Colors.white70 : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.isDarkMode ? Colors.white : Colors.indigo),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Login button
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: widget.isDarkMode ? Colors.indigo : Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                Text(
                  'Demo Credentials:\nUsername: demo\nPassword: password123',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
