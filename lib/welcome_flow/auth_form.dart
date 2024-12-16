import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        Center(
          child: SupaEmailAuth(
              onSignInComplete: (response) {}, onSignUpComplete: (response) {}),
        ),
        OutlinedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Skip SignIn'))
      ],
    );
  }
}
