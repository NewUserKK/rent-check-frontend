import 'package:flutter/material.dart';
import 'package:rent_checklist/src/auth/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: AuthForm(),
        ),
      ),
    );
  }
}
