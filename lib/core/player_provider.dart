import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'logger.dart';
import 'model/player.dart';
import 'model/user_details.dart';
import 'utils.dart';

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
    _saveToStorage();

    super.dispose();
  }

  // TODO: local storage
  PlayerProvider() {
    localStorage = SharedPreferencesAsync();

    _player = Player.instance;

    if (supabase.auth.currentUser != null) {
      _player.id = supabase.auth.currentUser!.id;
      _loadFromServer();
    } else {
      _loadFromStorage();
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
    if (jsonifiedString == null) return;

    final Map<String, dynamic> json = jsonDecode(jsonifiedString);

    _player = Player.fromJson(json);
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    if (_player.id == null) return;
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
    AppLogger.d('reloading');
    if (_player.id == null) {
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      final data = await supabase
          .from('user')
          .select('username, tag_number, details')
          .eq('id', _player.id!)
          .maybeSingle();

      // Should not happen, because hasInitialized() is called by the signUp logic
      if (data == null || data.isEmpty) {
        _loading = false;
        notifyListeners();
        return;
      }

      _player.username = data['username'] ?? Player.defaultUsername;
      _player.tagNumber = data['tag_number'] ?? Player.defaultTagNumber;
      if (data['details'] != null) {
        _player.update(
            details:
                UserDetails.fromJson(data['details'] as Map<String, dynamic>));
      } else {
        _player.update(details: null);
      }
    } on PostgrestException catch (exception, stackTrace) {
      AppLogger.d(exception.message);

      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Public method to refresh player data from server
  Future<void> refreshData() async {
    await _loadFromServer();
  }

  Future<void> _clearUserData() async {
    _player.username = Player.defaultUsername;
    _player.tagNumber = Player.defaultTagNumber;
    _player.id = null;
    _player.details = UserDetails();

    notifyListeners();
  }
}
