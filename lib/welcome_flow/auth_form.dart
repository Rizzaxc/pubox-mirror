import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/player.dart';
import '../misc/flutter_auth_ui/supabase_auth_ui.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  Future<bool> _waitUntilPlayerInitialized(BuildContext context) async {
    const checkFrequency = Duration(seconds: 1);
    const maxWaitTime = Duration(seconds: 5);
    final checkFn = context.read<Player>().hasInitialized;

    var initialized = false;
    final stopwatch = Stopwatch()..start();
    while (!initialized && stopwatch.elapsed < maxWaitTime) {
      initialized = await checkFn();
      await Future.delayed(checkFrequency);
    }
    stopwatch.stop();

    return initialized;
  }

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
                        onSignInComplete: (response) {
                          if (response.session != null) {
                            context.go('/home');
                          }
                        },
                        onSignUpComplete: (response) async {
                          if (response.session == null) return;
                          final hasPlayerInitialized = await _waitUntilPlayerInitialized(context);
                          if (hasPlayerInitialized && context.mounted) {
                            context.go('/home');
                          }
                          // TODO: show err msg if not initialized
                        }),
                    SupaSocialsAuth(socialProviders: [
                      OAuthProvider.google,
                      OAuthProvider.apple,
                      OAuthProvider.facebook
                    ], onSuccess: (session) async {
                      final hasPlayerInitialized = await _waitUntilPlayerInitialized(context);
                      if (hasPlayerInitialized && context.mounted) {
                        context.go('/home');
                      }
                      // TODO: show err msg if not initialized
                    }),
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
