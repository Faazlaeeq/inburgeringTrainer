import 'package:flutter/material.dart';
import 'package:inburgering_trainer/logic/helpers/auth_helper.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Handle Google Sign-In button press
              _handleGoogleSignIn();
            },
            child: const Text('Sign in with Google'),
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      AuthHelper().post();
      // Handle successful sign-in
    } catch (error) {
      debugPrint("faaz: error from signIn called function : $error");
    }
  }
}
