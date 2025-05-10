import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/model/enum.dart';
import '../core/model/timeslot.dart';

class HomeStateProvider extends ChangeNotifier {
  static const String _prefKey = 'STORED_HOME_STATE_PERSISTENT_KEY';

  // Current state
  City _city = City.hochiminh;
  Set<String> _districts = {};

  // Time slot selection state
  final List<Timeslot> _timeSlots = [];
  DayOfWeek _selectedDayOfWeek = DayOfWeek.everyday;
  DayChunk _selectedDayChunk = DayChunk.noon;

  // Pre-commit state
  City? _pendingCity;
  Set<String>? _pendingDistricts;
  List<Timeslot>? _pendingTimeSlots;
  DayOfWeek? _pendingSelectedDayOfWeek;
  DayChunk? _pendingSelectedDayChunk;
  bool _hasPendingChanges = false;

  // Initialization state
  bool _isInitialized = false;

  // SharedPreferences instance
  SharedPreferences? localStorage;

  HomeStateProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    // Load stored preferences
    localStorage = await SharedPreferences.getInstance();
    await _loadPersistedState();

    // Mark as initialized and notify listeners
    _isInitialized = true;
    notifyListeners();
  }

  // Getters
  bool get isInitialized => _isInitialized;

  City get city => _city;

  Set<String> get districts => _districts;

  List<Timeslot> get timeSlots => _timeSlots;

  DayOfWeek get selectedDayOfWeek => _selectedDayOfWeek;

  DayChunk get selectedDayChunk => _selectedDayChunk;

  bool get hasPendingChanges => _hasPendingChanges;

  // max 3 slots
  bool get canAddTimeSlot {
    final slots = _pendingTimeSlots ?? _timeSlots;
    final dayOfWeek = _pendingSelectedDayOfWeek ?? _selectedDayOfWeek;
    final dayChunk = _pendingSelectedDayChunk ?? _selectedDayChunk;
    final timeslot = Timeslot(dayOfWeek, dayChunk);
    return slots.length < 3 && !slots.contains(timeslot);
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
    if ((_pendingDistricts ?? _districts) == newDistricts) return;
    _pendingDistricts = newDistricts;
    _hasPendingChanges = true;
  }

  void updateSelectedDayOfWeek(DayOfWeek day) {
    if ((_pendingSelectedDayOfWeek ?? _selectedDayOfWeek) == day) return;
    _pendingSelectedDayOfWeek = day;
    _hasPendingChanges = true;
  }

  void updateSelectedDayChunk(DayChunk chunk) {
    if ((_pendingSelectedDayChunk ?? _selectedDayChunk) == chunk) return;
    _pendingSelectedDayChunk = chunk;
    _hasPendingChanges = true;
  }

  void addCurrentTimeSlotSelection() {
    if (!canAddTimeSlot) return;
    final dayOfWeek = _pendingSelectedDayOfWeek ?? _selectedDayOfWeek;
    final dayChunk = _pendingSelectedDayChunk ?? _selectedDayChunk;
    final timeslot = Timeslot(dayOfWeek, dayChunk);
    _pendingTimeSlots ??= List.from(_timeSlots);
    _pendingTimeSlots!.add(timeslot);
    _hasPendingChanges = true;
  }

  void removeTimeSlot(Timeslot slot) {
    _pendingTimeSlots ??= List.from(_timeSlots);
    _pendingTimeSlots!.removeWhere((item) =>
        item.dayOfWeek == slot.dayOfWeek && item.dayChunk == slot.dayChunk);
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

    if (_pendingTimeSlots != null) {
      _timeSlots.clear();
      _timeSlots.addAll(_pendingTimeSlots!);
      _pendingTimeSlots = null;
    }

    // reverts these to defaults
    _selectedDayOfWeek = DayOfWeek.everyday;
    _selectedDayChunk = DayChunk.noon;
    _pendingSelectedDayOfWeek = null;
    _pendingSelectedDayChunk = null;
    _hasPendingChanges = false;
    notifyListeners();
    _persistState(); // Persist changes after commit
  }

  // Discard pending changes
  void discardChanges() {
    _pendingCity = null;
    _pendingDistricts = null;
    _pendingTimeSlots = null;
    _pendingSelectedDayOfWeek = null;
    _pendingSelectedDayChunk = null;
    _hasPendingChanges = false;
  }

  // Persist current state to SharedPreferences using async API
  Future<void> _persistState() async {
    localStorage ??= await SharedPreferences.getInstance();

    try {
      // Convert timeSlots using their built-in JSON serialization
      final timeSlotsList = _timeSlots.map((slot) => slot.toJson()).toList();

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
      _timeSlots.clear();
      final timeSlotsList = stateMap['timeSlots'] as List;
      for (var slotMap in timeSlotsList) {
        _timeSlots.add(Timeslot.fromJson(Map<String, dynamic>.from(slotMap)));
      }

      log('load persisted home state succeeded');
      notifyListeners();
    } catch (e) {
      log('Failed to load persisted state: $e');
      localStorage?.remove(_prefKey);
      _timeSlots.clear();
      _city = City.hochiminh;
      _districts.clear();
    }
  }

  @override
  void dispose() {
    _persistState();
    super.dispose();
  }
}
