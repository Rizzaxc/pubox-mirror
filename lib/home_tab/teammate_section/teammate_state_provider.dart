import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/logger.dart';
import '../../core/model/timeslot.dart';
import '../../core/sport_switcher.dart';
import '../../core/utils.dart';
import '../model.dart';
import '../state_provider.dart';

class TeammateStateProvider with ChangeNotifier {
  static const int _pageSize = 12;

  final HomeStateProvider _homeStateProvider;
  final SelectedSportProvider _sportProvider;

  bool get isInitialized =>
      _homeStateProvider.isInitialized && _sportProvider.isInitialized;

  // Track current dependencies state
  // bool _isInitialized = false;
  // get isInitialized => _isInitialized;

  // Teammate data
  PagingState<int, TeammateModel> teammatePagingState = PagingState();

  TeammateStateProvider(this._sportProvider, this._homeStateProvider) {
    // Special handlers for sport changes vs general home state changes
    _sportProvider.addListener(_onDependenciesChanged);
    _homeStateProvider.addListener(_onDependenciesChanged);
  }

  void _onDependenciesChanged() {
    if (!isInitialized) return;
    loadData(isRefresh: true);
  }

  Future<void> loadData({bool isRefresh = false}) async {
    AppLogger.d('loading data. isRefresh $isRefresh sport ${_sportProvider.self} isInitialized $isInitialized');
    if (!isInitialized) return;
    if (!isRefresh && teammatePagingState.isLoading) return;

    // Update loading state
    teammatePagingState =
        teammatePagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // Clear existing items if refresh, else progress the key
      final newKey =
          isRefresh ? 1 : ((teammatePagingState.keys?.last ?? 0) + 1);

      await Future.delayed(Duration(milliseconds: 500));
      final List<TeammateModel> data = await _executeLoadData();
      final isLastPage = data.isEmpty;

      // Update state with new data
      teammatePagingState = teammatePagingState.copyWith(
        pages: isRefresh ? [data] : [...?teammatePagingState.pages, data],
        keys: isRefresh ? [newKey] : [...?teammatePagingState.keys, newKey],
        hasNextPage: !isLastPage,
        isLoading: false,
      );
    } catch (exception, stackTrace) {
      // Log error to Sentry and update state
      Sentry.captureException(exception, stackTrace: stackTrace);
      teammatePagingState = teammatePagingState.copyWith(
          isLoading: false, error: genericErrorMessage);
    } finally {
      // Always notify listeners and complete the operation
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sportProvider.removeListener(_onDependenciesChanged);
    _homeStateProvider.removeListener(_onDependenciesChanged);
    super.dispose();
  }

  Future<List<TeammateModel>> _executeLoadData() async {
    try {
      // Use the known private visibility ID (1) directly
      const int privateVisibilityId = 1;

      // Convert timeslots to JSON for filtering
      final List<String> timeslotsJsonStrings = _homeStateProvider.timeSlots
          .map((t) => jsonEncode(t.toJson()))
          .toList();

      // Join timeslots for the query
      final String playtimeCondition = timeslotsJsonStrings
          .map((t) => "playtime::jsonb @> '$t'")
          .join(' OR ');

      // Query lobbies that match our criteria
      final response = [];
      final params = {
        'sport_id': _sportProvider.id,
        'city_id': _homeStateProvider.city.dbIndex,
        'districts': _homeStateProvider.districts,
        'timeslots': Timeslot.listToJson(_homeStateProvider.timeSlots),
      };

      // Call a stored function that handles the complex query
      // final response = await supabase.rpc('home_teammate_data', params: params);

      return response as List<TeammateModel>;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      return [] as List<TeammateModel>;
    }
  }
}
