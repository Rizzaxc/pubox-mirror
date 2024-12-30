import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Player extends ChangeNotifier {
  late final StreamSubscription<AuthState> _authStateSubscription;

  static const defaultUsername = 'Guest';
  String _username = defaultUsername;

  get username => _username;

  static const defaultTagNumber = '0000';
  String _tagNumber = defaultTagNumber;

  get tagNumber => _tagNumber;

  String? _id;

  get id => _id;

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  Player() {
    if (supabase.auth.currentUser != null) {
      _id = supabase.auth.currentUser!.id;
      _populateUserData();
    }
    _authStateSubscription =
        supabase.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.userUpdated ||
          event == AuthChangeEvent.tokenRefreshed) {
        _id = data.session!.user.id;
        await _populateUserData();
      } else if (event == AuthChangeEvent.signedOut) {
        await _clearUserData();
      }
    });
  }

  Future<bool> hasInitialized() async {
    if (_id == null) return false;
    try {
      final data =
          await supabase.from('user').select().eq('id', _id!).maybeSingle();
      return (data != null && data.isNotEmpty);
    } on PostgrestException catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return false;
    }
  }

  Future<void> _populateUserData() async {
    if (_id == null) {
      return;
    }

    try {
      final data = await supabase
          .from('user')
          .select('username, tag_number')
          .eq('id', _id!)
          .maybeSingle();

      // Should not happen, because hasInitialized() is called by the signUp logic
      if (data == null || data.isEmpty) {
        return;
      }

      _username = data['username'];
      _tagNumber = data['tag_number'];

      debugPrint('user: $_username@$_tagNumber');
      notifyListeners();
    } on PostgrestException catch (exception, stackTrace) {
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _clearUserData() async {
    _username = defaultUsername;
    _tagNumber = defaultTagNumber;
    _id = null;

    notifyListeners();
  }
}
