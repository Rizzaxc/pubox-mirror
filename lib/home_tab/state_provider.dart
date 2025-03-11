

import 'package:flutter/widgets.dart';

import '../core/model/enum.dart';
import 'model.dart';

class HomeStateProvider extends ChangeNotifier {

  // filter state
  String searchVal = '';
  City city = City.hochiminh;
  List<String> districts = [];
  List<DayOfWeek> dayVal = [];
  List<DayChunk> dayChunkVal = [];

  // teammate tab state
  List<TeammateModel> teammateTabState = [];
  // challenge tab state
  List<ChallengeModel> challengeTabState = [];
  // neutral tab state
  // List<NeutralModel> neutralTabState = [];
  // location tab state
  // List<LocationModel> locationTabState = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HomeStateProvider();

  Future<void> startLoading() async {
    _isLoading = true;
    notifyListeners();
  }
  Future<void> cancelLoading() async {
    _isLoading = false;
    notifyListeners();
  }
}