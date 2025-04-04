import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/model/enum.dart';
import '../core/model/timeslot.dart';
import 'model.dart';

class HomeStateProvider extends ChangeNotifier {
  static const String _prefKey = 'STORED_HOME_STATE_PERSISTENT_KEY';

  City _city = City.hochiminh;
  Set<String> _districts = {};
  bool _isLoading = false;

  // Time slot selection state
  final List<Timeslot> _timeSlots = [];
  DayOfWeek _selectedDayOfWeek = DayOfWeek.everyday;
  DayChunk _selectedDayChunk = DayChunk.early;

  // SharedPreferences instance
  SharedPreferences? localStorage;

  HomeStateProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    localStorage = await SharedPreferences.getInstance();
    await _loadPersistedState();
  }

  // Getters
  City get city => _city;
  Set<String> get districts => _districts;
  bool get isLoading => _isLoading;
  List<Timeslot> get timeSlots => _timeSlots;
  DayOfWeek get selectedDayOfWeek => _selectedDayOfWeek;
  DayChunk get selectedDayChunk => _selectedDayChunk;

  bool get canAddTimeSlot =>
      _timeSlots.length < 3 &&
      !_timeSlots.contains(Timeslot(_selectedDayOfWeek, _selectedDayChunk));

  // Update methods
  void updateCity(City newCity) {
    if (_city == newCity) return;
    _city = newCity;
    _districts = {}; // no cross-city locations
    notifyListeners();
  }

  void updateDistricts(Set<String> newDistricts) {
    if (newDistricts.length > 3) return;
    _districts = newDistricts;
    notifyListeners();
  }

  void updateSelectedDayOfWeek(DayOfWeek day) {
    _selectedDayOfWeek = day;
    notifyListeners();
  }

  void updateSelectedDayChunk(DayChunk chunk) {
    _selectedDayChunk = chunk;
    notifyListeners();
  }

  void addCurrentTimeSlotSelection() {
    if (_timeSlots.length < 3 &&
        !_timeSlots.contains(Timeslot(_selectedDayOfWeek, _selectedDayChunk))) {
      _timeSlots.add(Timeslot(_selectedDayOfWeek, _selectedDayChunk));
      notifyListeners();
    }
  }

  void removeTimeSlot(Timeslot slot) {
    _timeSlots.removeWhere((item) =>
        item.dayOfWeek == slot.dayOfWeek && item.dayChunk == slot.dayChunk);
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implement API call or data refresh logic here
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    } catch (e) {
      // Handle errors
    } finally {
      _isLoading = false;
      notifyListeners();

      // Persist state to local storage
      await _persistState();
    }
  }

  // Persist current state to SharedPreferences using async API
  Future<void> _persistState() async {
    localStorage ??= await SharedPreferences.getInstance();

    try {
      // Convert timeSlots to a serializable format
      final timeSlotsList = _timeSlots
          .map((slot) => {
                'dayOfWeek': slot.dayOfWeek.index,
                'dayChunk': slot.dayChunk.index,
              })
          .toList();

      // Create a map of the current state
      final stateMap = {
        'city': _city.index,
        'districts': _districts.toList(),
        'timeSlots': timeSlotsList,
        'selectedDayOfWeek': _selectedDayOfWeek.index,
        'selectedDayChunk': _selectedDayChunk.index,
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
        final dayOfWeek = DayOfWeek.values[slotMap['dayOfWeek'] as int];
        final dayChunk = DayChunk.values[slotMap['dayChunk'] as int];
        _timeSlots.add(Timeslot(dayOfWeek, dayChunk));
      }

      // Restore selected values
      _selectedDayOfWeek =
          DayOfWeek.values[stateMap['selectedDayOfWeek'] as int];
      _selectedDayChunk = DayChunk.values[stateMap['selectedDayChunk'] as int];

      notifyListeners();
    } catch (e) {
      log('Failed to load persisted state: $e');
    }
  }

  @override
  void dispose() {
    // Ensure we persist state when the provider is disposed
    _persistState();
    super.dispose();
  }
}
