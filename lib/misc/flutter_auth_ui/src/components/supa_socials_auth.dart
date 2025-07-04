import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/icons/main.dart';
import '../../../../core/utils.dart';
import '../localizations/supa_socials_auth_localization.dart';

extension on OAuthProvider {
  IconData get iconData => switch (this) {
        OAuthProvider.apple => FontAwesomeIcons.apple,
        OAuthProvider.discord => FontAwesomeIcons.discord,
        OAuthProvider.facebook => FontAwesomeIcons.facebook,
        OAuthProvider.google => FontAwesomeIcons.google,
        OAuthProvider.linkedin => FontAwesomeIcons.linkedin,
        _ => Icons.close,
      };

  Color get btnBgColor => switch (this) {
        OAuthProvider.apple => Colors.black,
        OAuthProvider.discord => Colors.purple,
        OAuthProvider.facebook => const Color(0xFF3b5998),
        OAuthProvider.google => Colors.white,
        OAuthProvider.linkedin => const Color.fromRGBO(0, 136, 209, 1),
        _ => Colors.black,
      };

  String get labelText =>
      'Continue with ${name[0].toUpperCase()}${name.substring(1)}';
}

enum SocialButtonVariant {
  /// Displays the social login buttons horizontally with icons.
  icon,

  /// Displays the social login buttons vertically with icons and text labels.
  iconAndText,
}

class NativeGoogleAuthConfig {
  /// Web Client ID that you registered with Google Cloud.
  ///
  /// Required to perform native Google Sign In on Android
  final String? webClientId;

  /// iOS Client ID that you registered with Google Cloud.
  ///
  /// Required to perform native Google Sign In on iOS
  final String? iosClientId;

  const NativeGoogleAuthConfig({
    this.webClientId,
    this.iosClientId,
  });
}

/// UI Component to create social login form
class SupaSocialsAuth extends StatefulWidget {
  /// Defines native google provider to show in the form
  final NativeGoogleAuthConfig? nativeGoogleAuthConfig;

  /// Whether to use native Apple sign in on iOS and macOS
  final bool enableNativeAppleAuth;

  /// List of social providers to show in the form
  final List<OAuthProvider> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  ///
  /// You can control the appearance through `ElevatedButtonTheme` when set to false.
  final bool colored;

  /// Whether or not to show the icon only or icon and text
  final SocialButtonVariant socialButtonVariant;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session session) onSuccess;

  /// Method to be called when the auth action threw an exception
  final void Function(Object error)? onError;

  /// Whether to show a SnackBar after a successful sign in
  final bool showSuccessSnackBar;

  /// OpenID scope(s) for provider authorization request (ex. '.default')
  final Map<OAuthProvider, String>? scopes;

  /// Parameters to include in provider authorization request (ex. {'prompt': 'consent'})
  final Map<OAuthProvider, Map<String, String>>? queryParams;

  /// Localization for the form
  final SupaSocialsAuthLocalization localization;

  /// Custom LaunchMode support
  final LaunchMode authScreenLaunchMode;

  const SupaSocialsAuth({
    super.key,
    this.nativeGoogleAuthConfig,
    this.enableNativeAppleAuth = true,
    required this.socialProviders,
    this.colored = true,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
    this.socialButtonVariant = SocialButtonVariant.icon,
    this.showSuccessSnackBar = true,
    this.scopes,
    this.queryParams,
    this.localization = const SupaSocialsAuthLocalization(),
    this.authScreenLaunchMode = LaunchMode.platformDefault,
  });

  @override
  State<SupaSocialsAuth> createState() => _SupaSocialsAuthState();
}

class _SupaSocialsAuthState extends State<SupaSocialsAuth> {
  late final StreamSubscription<AuthState> _gotrueSubscription;
  late final SupaSocialsAuthLocalization localization;

  /// Performs Google sign in on Android and iOS
  Future<AuthResponse> _nativeGoogleSignIn({
    required String? webClientId,
    required String? iosClientId,
  }) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw const AuthException(
          'No Access Token found from Google sign in result.');
    }
    if (idToken == null) {
      throw const AuthException(
          'No ID Token found from Google sign in result.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Performs Apple sign in on iOS or macOS
  Future<AuthResponse> _nativeAppleSignIn() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated Apple sign in credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  void initState() {
    super.initState();
    localization = widget.localization;
    _gotrueSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        widget.onSuccess.call(session);
        context.showToast(localization.successSignInMessage);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gotrueSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    final googleAuthConfig = widget.nativeGoogleAuthConfig;
    final isNativeAppleAuthEnabled = widget.enableNativeAppleAuth;
    final coloredBg = widget.colored == true;

    if (providers.isEmpty) {
      return ErrorWidget(Exception('Social provider list cannot be empty'));
    }

    final authButtons = List.generate(providers.length, (index) {
      final socialProvider = providers[index];

      onAuthButtonPressed() async {
        try {
          // Check if native Google login should be performed
          if (socialProvider == OAuthProvider.google) {
            final webClientId = googleAuthConfig?.webClientId;
            final iosClientId = googleAuthConfig?.iosClientId;
            final shouldPerformNativeGoogleSignIn =
                (webClientId != null && !kIsWeb && Platform.isAndroid) ||
                    (iosClientId != null && !kIsWeb && Platform.isIOS);
            if (shouldPerformNativeGoogleSignIn) {
              await _nativeGoogleSignIn(
                webClientId: webClientId,
                iosClientId: iosClientId,
              );
              return;
            }
          }

          // Check if native Apple login should be performed
          if (socialProvider == OAuthProvider.apple) {
            final shouldPerformNativeAppleSignIn =
                (isNativeAppleAuthEnabled && !kIsWeb && Platform.isIOS) ||
                    (isNativeAppleAuthEnabled && !kIsWeb && Platform.isMacOS);
            if (shouldPerformNativeAppleSignIn) {
              await _nativeAppleSignIn();
              return;
            }
          }

          final user = supabase.auth.currentUser;
          if (user?.isAnonymous == true) {
            await supabase.auth.linkIdentity(
              socialProvider,
              redirectTo: widget.redirectUrl,
              scopes: widget.scopes?[socialProvider],
              queryParams: widget.queryParams?[socialProvider],
            );
            return;
          }

          await supabase.auth.signInWithOAuth(
            socialProvider,
            redirectTo: widget.redirectUrl,
            scopes: widget.scopes?[socialProvider],
            queryParams: widget.queryParams?[socialProvider],
            authScreenLaunchMode: widget.authScreenLaunchMode,
          );
        } on AuthException catch (error) {
          if (widget.onError == null && context.mounted) {
            context.showToast(error.message, type: ToastificationType.error);
          } else {
            widget.onError?.call(error);
          }
        } catch (error) {
          if (widget.onError == null && context.mounted) {
            context.showToast('${localization.unexpectedError}: $error',
                type: ToastificationType.error);
          } else {
            widget.onError?.call(error);
          }
        }
      }

      final btnBody = () {
        switch (socialProvider) {
          case OAuthProvider.google:
            return SvgPicture(
              PuboxIcons.googleRound,
              height: 56,
              width: 56,
            );

          case OAuthProvider.apple:
            return Image.asset(
              './assets/icons/apple_round.png',
              height: 56,
              width: 56,
            );
          case OAuthProvider.facebook:
            return Icon(OAuthProvider.facebook.iconData,
                size: 56, color: OAuthProvider.facebook.btnBgColor);
          default:
            return Icon(Icons.question_mark);
        }
      }();

      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 4,
          ),
          onPressed: onAuthButtonPressed,
          child: btnBody);
    });
    return SafeArea(
      child: Column(
        spacing: 16,
        children: [
          const Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 1.2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Socials',
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1.2,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 16,
            alignment: WrapAlignment.spaceEvenly,
            children: authButtons,
          ),
        ],
      ),
    );
  }
}
