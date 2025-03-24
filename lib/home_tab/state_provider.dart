import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../core/model/enum.dart';
import '../core/model/timeslot.dart';
import 'model.dart';

class HomeStateProvider extends ChangeNotifier {
  City _city = City.hochiminh;
  Set<String> _districts = {};
  bool _isLoading = false;

  HomeStateProvider();

  City get city => _city;
  Set<String> get districts => _districts;
  bool get isLoading => _isLoading;

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

  // Time slot selection state
  final List<Timeslot> _timeSlots = [];
  DayOfWeek _selectedDayOfWeek = DayOfWeek.everyday;
  DayChunk _selectedDayChunk = DayChunk.early;

  // Getters
  List<Timeslot> get timeSlots => _timeSlots;
  DayOfWeek get selectedDayOfWeek => _selectedDayOfWeek;
  DayChunk get selectedDayChunk => _selectedDayChunk;

  bool get canAddTimeSlot =>
      _timeSlots.length < 3 &&
          !_timeSlots.contains(Timeslot(_selectedDayOfWeek, _selectedDayChunk));

  // Update methods
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
    item.dayOfWeek == slot.dayOfWeek &&
        item.dayChunk == slot.dayChunk);
    notifyListeners();
  }


  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implement API call or data refresh logic here
      log(districts.toString());
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    } catch (e) {
      // Handle errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}