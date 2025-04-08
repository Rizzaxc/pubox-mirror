import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/model/enum.dart';
import '../core/model/timeslot.dart';
import '../core/utils.dart';
import 'model.dart';

class HomeStateProvider extends ChangeNotifier {
  static const String _prefKey = 'STORED_HOME_STATE_PERSISTENT_KEY';
  static const _batchSize = 12;

  City _city = City.hochiminh;
  Set<String> _districts = {};
  bool _isLoading = false;

  // Time slot selection state
  final List<Timeslot> _timeSlots = [];
  DayOfWeek _selectedDayOfWeek = DayOfWeek.everyday;
  DayChunk _selectedDayChunk = DayChunk.early;

  // SharedPreferences instance
  SharedPreferences? localStorage;

  // Teammate data
  PagingState<int, TeammateModel> teammatePagingState = PagingState();

  // Challenger data
  // Neutral data
  // Location data

  HomeStateProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    // Load stored preferences
    localStorage = await SharedPreferences.getInstance();
    await _loadPersistedState();

    // Load initial data
    refreshData();
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

  final List<TeammateModel> _mockTeammates = [
    TeammateModel(
      teammateResultType: TeammateResultType.player,
      resultTitle: "GamerPro1999",
      location: ["Manchester", "UK"],
      playtime: Timeslot(DayOfWeek.monday, DayChunk.noon),
      details: {
        "skill": "Expert",
        "games": ["Valorant", "CS:GO"]
      },
      compatScore: 0.92,
      searchableId: "gp99_12345",
    ),
    TeammateModel(
      teammateResultType: TeammateResultType.lobby,
      resultTitle: "Weekend Warriors",
      location: ["Online", "Global"],
      playtime: Timeslot(DayOfWeek.saturday, DayChunk.night),
      details: {
        "players": 6,
        "games": ["Apex Legends"]
      },
      compatScore: 0.78,
      searchableId: "ww_lobby_67890",
    ),
    TeammateModel(
      teammateResultType: TeammateResultType.player,
      resultTitle: "CasualGamer42",
      location: ["London", "UK"],
      playtime: Timeslot(DayOfWeek.even, DayChunk.early),
      details: {
        "skill": "Intermediate",
        "games": ["Fortnite", "Rocket League"]
      },
      compatScore: 0.65,
      searchableId: "cg42_54321",
    ),
  ];

  final List<TeammateModel> _mockTeammates2 = [
    TeammateModel(
      teammateResultType: TeammateResultType.player,
      resultTitle: "GamerPro1999",
      location: ["China", "Shanghai"],
      playtime: Timeslot(DayOfWeek.monday, DayChunk.noon),
      details: {
        "skill": "Expert",
        "games": ["Dota", "PoE"]
      },
      compatScore: 0.92,
      searchableId: "gp99_12345",
    ),
    TeammateModel(
      teammateResultType: TeammateResultType.lobby,
      resultTitle: "Weekend Warriors",
      location: ["Online", "Global"],
      playtime: Timeslot(DayOfWeek.saturday, DayChunk.night),
      details: {
        "players": 6,
        "games": ["Apex Legends"]
      },
      compatScore: 0.78,
      searchableId: "ww_lobby_67890",
    ),
    TeammateModel(
      teammateResultType: TeammateResultType.player,
      resultTitle: "CasualGamer42",
      location: ["London", "UK"],
      playtime: Timeslot(DayOfWeek.even, DayChunk.early),
      details: {
        "skill": "Intermediate",
        "games": ["Fortnite", "Rocket League"]
      },
      compatScore: 0.65,
      searchableId: "cg42_54321",
    ),
  ];

  Future<void> refreshData() async {
    _isLoading = true;

    try {
      // TODO: Load the initial batch of all 4 tabs: teammate, challenger, neutral, location
      if (teammatePagingState.isLoading) return;
      teammatePagingState =
          teammatePagingState.copyWith(isLoading: true, error: null);
      notifyListeners();
      teammatePagingState.items?.clear();
      final freshTeammates = _mockTeammates;
      final newKey = 1;
      final isLastPage = freshTeammates.isEmpty;

      teammatePagingState = teammatePagingState.copyWith(
        pages: [freshTeammates],
        keys: [...?teammatePagingState.keys, newKey],
        hasNextPage: !isLastPage,
        isLoading: false,
      );
    } catch (exception, stackTrace) {
      // Handle errors
      Sentry.captureException(exception, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      teammatePagingState = teammatePagingState.copyWith(isLoading: false);

      notifyListeners();

      // Persist state to local storage
      await _persistState();
    }
  }

  Future<void> loadTeammate() async {
    if (teammatePagingState.isLoading) return;

    try {
      // TODO
      teammatePagingState =
          teammatePagingState.copyWith(isLoading: true, error: null);
      notifyListeners();

      await Future.delayed(Duration(seconds: 2));
      final newKey = (teammatePagingState.keys?.last ?? 0) + 1;

      teammatePagingState = teammatePagingState.copyWith(
        pages: [...?teammatePagingState.pages, _mockTeammates2],
        keys: [...?teammatePagingState.keys, newKey],
        hasNextPage: false,
        isLoading: false,
      );
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      teammatePagingState =
          teammatePagingState.copyWith(error: genericErrorMessage);
    } finally {
      teammatePagingState = teammatePagingState.copyWith(isLoading: false);
      notifyListeners();
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
