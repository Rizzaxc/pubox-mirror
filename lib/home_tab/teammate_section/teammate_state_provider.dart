import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
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

  // Wrapper for the execute function
  CancelableOperation<List<TeammateModel>>? _cancelableExecuteLoad;

  TeammateStateProvider(this._homeStateProvider, this._sportProvider) {
    _homeStateProvider.addListener(_onDependenciesChanged);

    _sportProvider.addListener(_onDependenciesChanged);
  }

  void _onDependenciesChanged() {
    if (!isInitialized) return;
    loadData(isRefresh: true);
  }

  Future<void> loadData({bool isRefresh = false}) async {
    AppLogger.d('loading data. isRefresh $isRefresh sport ${_sportProvider.self} isInitialized $isInitialized');
    if (!isInitialized) return;

    // If not a complete refresh and a request is already fired
    if (!isRefresh && teammatePagingState.isLoading) return;

    // If force refresh, cancel any existing request
    if (isRefresh) {
      _cancelableExecuteLoad?.cancel();
      _cancelableExecuteLoad = null;
    }

    // Update loading state
    teammatePagingState =
        teammatePagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // Clear existing items if refresh, else progress the key
      final newKey =
          isRefresh ? 1 : ((teammatePagingState.keys?.last ?? 0) + 1);

      _cancelableExecuteLoad = CancelableOperation.fromFuture(
        _executeLoadData(), onCancel: () {}
      );

      await Future.delayed(Duration(seconds: 1));

      final List<TeammateModel> data = await _cancelableExecuteLoad?.value ?? [];
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
      final List<String> timeslotsJsonStrings = _homeStateProvider.timeslots
          .map((t) => jsonEncode(t.toJson()))
          .toList();

      // Join timeslots for the query
      final String playtimeCondition = timeslotsJsonStrings
          .map((t) => "playtime::jsonb @> '$t'")
          .join(' OR ');

      // Query lobbies that match our criteria
      final List<TeammateModel> response = [];
      final params = {
        'sport_id': _sportProvider.id,
        'city_id': _homeStateProvider.city.dbIndex,
        'districts': _homeStateProvider.districts,
        'timeslots': Timeslot.listToJson(_homeStateProvider.timeslots),
      };

      // Call a stored function that handles the complex query
      // final response = await supabase.rpc('home_teammate_data', params: params);

      return response;
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      AppLogger.d(exception.toString());

      return [] as List<TeammateModel>;
    }
  }
}
