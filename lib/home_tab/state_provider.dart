import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/logger.dart';
import '../core/model/enum.dart';
import '../core/model/timeslot.dart';
import '../core/player_provider.dart';

class HomeStateProvider extends ChangeNotifier {
  static const String _prefKey = 'STORED_HOME_STATE_PERSISTENT_KEY';

  // Current state
  City _city = City.hochiminh;
  Set<String> _districts = {};

  // Time slot selection state
  final List<Timeslot> _timeslots = [];


  // Pre-commit state
  City? _pendingCity;
  Set<String>? _pendingDistricts;
  List<Timeslot>? _pendingTimeslots;

  bool _hasPendingChanges = false;

  // Initialization state
  bool _isInitialized = false;

  // SharedPreferences instance
  SharedPreferences? localStorage;

  // Player provider reference
  final PlayerProvider _playerProvider;

  HomeStateProvider(this._playerProvider) {
    _initPrefs();
    _playerProvider.addListener(initializeTimeslotWithUserPlaytime);

  }

  Future<void> _initPrefs() async {
    // Load stored preferences
    localStorage = await SharedPreferences.getInstance();
    await _loadPersistedState();

    // Mark as initialized and notify listeners
    _isInitialized = true;
    notifyListeners();
  }

  // Initialize timeslots with user's playtime if it exists
  void initializeTimeslotWithUserPlaytime() {
    final userPlaytime = _playerProvider.details?.playtime ?? [];
    // AppLogger.d(jsonEncode(userPlaytime));

    if (userPlaytime.isEmpty) return;
    _timeslots.clear();
    _timeslots.addAll(userPlaytime);
    _pendingTimeslots = null;
    notifyListeners();
    // AppLogger.d('Notified Home of new playtime');

  }

  // Getters
  bool get isInitialized => _isInitialized;

  City get city => _city;

  Set<String> get districts => _districts;

  List<Timeslot> get timeslots => _timeslots;

  bool get hasPendingChanges => _hasPendingChanges;

  // max 3 slots
  bool canAddTimeSlot(Timeslot toAdd) {
    final slots = _pendingTimeslots ?? _timeslots;
    return slots.length < 3 && !slots.contains(toAdd);
  }

  // Update methods (pre-commit)
  void updateCity(City newCity) {
    if ((_pendingCity ?? _city) == newCity) return;
    _pendingCity = newCity;
    // Clear districts when city changes
    _pendingDistricts = {};

    _hasPendingChanges = true;
  }

  void updateDistricts(Set<String> newDistricts) {
    if (newDistricts.length > 3) return;
    _pendingDistricts = newDistricts;
    _hasPendingChanges = true;
  }

  void updateTimeslots(List<Timeslot> newTimeslots) {
    if (newTimeslots.length >= 3) return;
    _pendingTimeslots = newTimeslots;
    _hasPendingChanges = true;
  }

  // Commit changes and notify listeners
  void commit() {
    if (!_hasPendingChanges) return;

    if (_pendingCity != null) {
      _city = _pendingCity!;
      _pendingCity = null;
    }

    if (_pendingDistricts != null) {
      _districts = _pendingDistricts!;
      _pendingDistricts = null;
    }

    if (_pendingTimeslots != null) {
      _timeslots.clear();
      _timeslots.addAll(_pendingTimeslots!);
      _pendingTimeslots = null;
    }

    _hasPendingChanges = false;
    notifyListeners();
    _persistState(); // Persist changes after commit
  }

  // Discard pending changes
  void discardChanges() {
    _pendingCity = null;
    _pendingDistricts = null;
    _pendingTimeslots = null;

    _hasPendingChanges = false;
  }

  // Persist current state to SharedPreferences using async API
  Future<void> _persistState() async {
    localStorage ??= await SharedPreferences.getInstance();

    try {
      // Convert timeSlots using their built-in JSON serialization
      final timeSlotsList = _timeslots.map((slot) => slot.toJson()).toList();

      // Create a map of the current state
      final stateMap = {
        'city': _city.index,
        'districts': _districts.toList(),
        'timeSlots': timeSlotsList,
      };

      // Save as JSON string using the async API
      await localStorage!.setString(_prefKey, jsonEncode(stateMap));
    } catch (e) {
      // TODO
      log('Failed to persist state: $e');
    }
  }

  // Load persisted state from SharedPreferences using async API
  Future<void> _loadPersistedState() async {
    if (localStorage == null) return;

    try {
      final stateJson = localStorage!.getString(_prefKey);

      if (stateJson == null) return;

      final stateMap = jsonDecode(stateJson) as Map<String, dynamic>;

      // Restore city
      _city = City.values[stateMap['city'] as int];

      // Restore districts
      _districts = Set<String>.from(stateMap['districts'] as List);

      // Restore time slots
      _timeslots.clear();
      final timeSlotsList = stateMap['timeSlots'] as List;
      for (var slotMap in timeSlotsList) {
        _timeslots.add(Timeslot.fromJson(Map<String, dynamic>.from(slotMap)));
      }

      notifyListeners();
    } catch (e) {
      localStorage?.remove(_prefKey);
      _timeslots.clear();
      _city = City.hochiminh;
      _districts.clear();
    }
  }

  @override
  void dispose() {
    _persistState();
    _playerProvider.removeListener(initializeTimeslotWithUserPlaytime);

    super.dispose();
  }
}
