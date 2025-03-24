import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../core/model/enum.dart';
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