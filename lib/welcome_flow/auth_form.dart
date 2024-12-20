import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../misc/flutter_auth_ui/supabase_auth_ui.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  spacing: 36,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SupaEmailAuth(
                        onSignInComplete: (response) {},
                        onSignUpComplete: (response) {}),
                    SupaSocialsAuth(socialProviders: [
                      OAuthProvider.google,
                      OAuthProvider.apple,
                      OAuthProvider.facebook
                    ], onSuccess: (session) => context.go('/home')),
                  ],
                ),
                TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text(
                      'Bỏ qua Đăng nhập',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black54),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
