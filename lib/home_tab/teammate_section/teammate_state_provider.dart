import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/model/enum.dart';
import '../../core/model/timeslot.dart';
import '../../core/sport_switcher.dart';
import '../../core/utils.dart';
import '../model.dart';
import '../state_provider.dart';

class TeammateStateProvider with ChangeNotifier {
  final HomeStateProvider _homeStateProvider;
  final SelectedSportProvider _sportProvider;

  // Teammate data
  PagingState<int, TeammateModel> teammatePagingState = PagingState();

  // Fully refresh if dependencies change
  TeammateStateProvider(this._sportProvider, this._homeStateProvider) {
    _sportProvider.addListener(refreshData);
    _homeStateProvider.addListener(refreshData);

    refreshData();
  }

  Future<void> refreshData() async {
    if (teammatePagingState.isLoading) return;
    teammatePagingState =
        teammatePagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      teammatePagingState.items?.clear();
      final newKey = 1;
      // Fetch data from database
      // final freshTeammates = await _fetchData(offset: newKey);
      final List<TeammateModel> freshTeammates = [];
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
      teammatePagingState = teammatePagingState.copyWith(
          isLoading: false, error: genericErrorMessage);
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadTeammate() async {
    if (teammatePagingState.isLoading) return;
    teammatePagingState =
        teammatePagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // TODO
      await Future.delayed(Duration(seconds: 2));
      final newKey = (teammatePagingState.keys?.last ?? 0) + 1;
      final List<TeammateModel> nextTeammates = [];

      teammatePagingState = teammatePagingState.copyWith(
        pages: [...?teammatePagingState.pages, nextTeammates],
        keys: [...?teammatePagingState.keys, newKey],
        hasNextPage: false,
        isLoading: false,
      );
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      teammatePagingState = teammatePagingState.copyWith(
          isLoading: false, error: genericErrorMessage);
    } finally {
      notifyListeners();
    }
  }

  // Future<List<TeammateModel>> _fetchData({required int offset}) async {
  // try {
  //   // Simulate network delay
  //   await Future.delayed(const Duration(seconds: 1));
  //
  //   final response = await supabase
  //       .from('teammates')
  //       .select()
  //       .range((offset - 1) * 10, offset * 10 - 1);
  //
  // }
  // }
}
