import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    String email = _emailController.text.trim();
  String password = _passwordController.text;

  // Simple validation
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter email and password")),
    );
    return;
  }

  // Navigate to home screen
  Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  child: Text("Login"),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    print("Navigate to forgot password");
                  },
                  child: Text("Forgot Password?"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        print("Navigate to signup screen");
                      },
                      child: Text("Sign Up"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
