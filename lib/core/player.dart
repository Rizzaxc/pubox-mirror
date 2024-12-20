import 'dart:async';

import 'package:flutter/material.dart';
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
    final data = await supabase
        .from('user')
        .select()
        .eq('id', _id!)
        .single();
    return data.isNotEmpty;
  }

  Future<void> _populateUserData() async {
    if (_id == null) return;
    final data = await supabase
        .from('user')
        .select('username, tag_number')
        .eq('id', _id!)
        .single();

    // Should not happen, because hasInitialized() is called by the signUp logic
    if (data.isEmpty) {
      return;
    }

    _username = data['username'];
    _tagNumber = data['tagNumber'] as String;

    notifyListeners();
  }

  Future<void> _clearUserData() async {
    _username = defaultUsername;
    _tagNumber = defaultTagNumber;
    _id = null;

    notifyListeners();
  }
}
