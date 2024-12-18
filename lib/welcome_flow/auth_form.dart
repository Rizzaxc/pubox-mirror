import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../misc/flutter_auth_ui/supabase_auth_ui.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        children: [
          SupaEmailAuth(
              onSignInComplete: (response) {}, onSignUpComplete: (response) {}),
          SupaSocialsAuth(
              socialProviders: [OAuthProvider.google, OAuthProvider.apple, OAuthProvider.facebook],
              onSuccess: (session) => context.go('/home')),
          const SizedBox(height: 128),
          TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Bỏ qua Đăng nhập', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),))
        ],
      ),
    );
  }
}
