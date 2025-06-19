import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../core/logger.dart';
import '../core/player_provider.dart';
import '../misc/flutter_auth_ui/supabase_auth_ui.dart';

class AuthForm extends StatelessWidget {
  const AuthForm._();

  static final _instance = AuthForm._();

  static AuthForm get instance => _instance;

  Future<bool> _awaitPlayerInitialized(BuildContext context) async {
    const initialDelay = Duration(milliseconds: 100);
    const checkFrequency = Duration(seconds: 1);
    const maxWaitTime = Duration(seconds: 5);
    final checkFn = context.read<PlayerProvider>().hasInitialized;

    var initialized = false;
    final stopwatch = Stopwatch()..start();
    await Future.delayed(initialDelay);
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
              spacing: 48,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SupaEmailAuth(onSignInComplete: (response) {
                  // Should not be null, but just in case
                  if (response.session == null) return;
                  // return to the triggering tab
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                }, onSignUpComplete: (response) async {
                  if (response.session == null) return;
                  final hasPlayerInitialized =
                      await _awaitPlayerInitialized(context);

                  // TODO: show err msg if not initialized
                  if (!hasPlayerInitialized) return;

                  // happy case
                  if (context.mounted) {
                    // return to the triggering tab
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  }
                }),
                SupaSocialsAuth(
                    socialProviders: [
                      OAuthProvider.google,
                      OAuthProvider.apple,
                      OAuthProvider.facebook
                    ],
                    onError: (error) {
                      AppLogger.e(error.toString());
                      Sentry.captureException(error);
                    },
                    onSuccess: (session) async {
                      final hasPlayerInitialized =
                          await _awaitPlayerInitialized(context);
                      // TODO: show err msg if not initialized
                      if (!hasPlayerInitialized) return;

                      // happy case
                      if (context.mounted) {
                        context.go('/home');
                        return;
                      }
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
