import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewModel/blocs/auth/auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Sign-Up Form Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: Colors.black45,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Create an Account",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Sign up to get started",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          SizedBox(height: 20),
                
                          // Username Input
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                              labelText: "Username",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(height: 15),
                
                          // Email Input
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                              labelText: "Email",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(height: 15),
                
                          // Password Input
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.purple),
                              labelText: "Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(height: 20),
                
                          // BlocConsumer for Sign-Up Button
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is Authenticated) {
                                Navigator.pushReplacementNamed(context, "/home");
                              } else if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                                );
                              }
                            },
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        _emailController.text,
                                        _passwordController.text,
                                        _usernameController.text,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 5,
                                  ),
                                  child: state is AuthLoading
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                
                          // Redirect to Login
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                            child: Text(
                              "Already have an account? Log in",
                              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
