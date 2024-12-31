import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'model/player.dart';

final supabase = Supabase.instance.client;

class PlayerProvider extends ChangeNotifier {
  static const storedPlayerKey = 'STORED_PLAYER_PERSISTENT_KEY';
  late final SharedPreferencesAsync localStorage;

  late final StreamSubscription<AuthState> _authStateSubscription;

  late Player _player;

  Player get player => _player;

  bool _loading = false;

  bool get loading => _loading;

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  // TODO: local storage
  PlayerProvider() {
    localStorage = SharedPreferencesAsync();

    _player = Player.instance;
    // _loadFromStorage();

    if (supabase.auth.currentUser != null) {
      _player.id = supabase.auth.currentUser!.id;
      _loadFromServer();
    }
    _authStateSubscription =
        supabase.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.userUpdated ||
          event == AuthChangeEvent.tokenRefreshed) {
        _player.id = data.session!.user.id;
        await _loadFromServer();
      } else if (event == AuthChangeEvent.signedOut) {
        await _clearUserData();
      }
    });
  }

  Future<void> _loadFromStorage() async {
    final jsonifiedString = await localStorage.getString(storedPlayerKey);
    final Map<String, dynamic> json = jsonifiedString != null ? jsonDecode(jsonifiedString) : {};

    _player = Player.fromJson(json);
  }

  Future<void> _saveToStorage() async {
    await localStorage.setString(storedPlayerKey, jsonEncode(_player.toJson()));
  }

  Future<bool> hasInitialized() async {
    if (_player.id == null) return false;
    try {
      final data = await supabase
          .from('user')
          .select()
          .eq('id', _player.id!)
          .maybeSingle();
      return (data != null && data.isNotEmpty);
    } on PostgrestException catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return false;
    }
  }

  Future<void> _loadFromServer() async {
    if (_player.id == null) {
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      final data = await supabase
          .from('user')
          .select('username, tag_number')
          .eq('id', _player.id!)
          .maybeSingle();

      // Should not happen, because hasInitialized() is called by the signUp logic
      if (data == null || data.isEmpty) {
        return;
      }

      _player.username = data['username'];
      _player.tagNumber = data['tag_number'];
    } on PostgrestException catch (exception, stackTrace) {
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _clearUserData() async {
    _player.username = Player.defaultUsername;
    _player.tagNumber = Player.defaultTagNumber;
    _player.id = null;

    notifyListeners();
  }
}
