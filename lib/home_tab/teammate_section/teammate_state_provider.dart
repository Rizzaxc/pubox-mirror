import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/model/enum.dart';
import '../../core/sport_switcher.dart';
import '../../core/utils.dart';
import '../model.dart';
import '../state_provider.dart';

class TeammateStateProvider with ChangeNotifier {
  static const int _pageSize = 12;
  static const int debounceDuration = 250;

  late HomeStateProvider _homeStateProvider;
  late SelectedSportProvider _sportProvider;

  // Track current dependencies state
  int _currentSportId = 1;
  bool _isInitializing = true;

  // Debounce timer to prevent multiple refreshes
  Timer? _debounceTimer;

  // Track refresh operations
  Completer<void>? _refreshCompleter;

  // Teammate data
  PagingState<int, TeammateModel> teammatePagingState = PagingState();

  TeammateStateProvider(this._sportProvider, this._homeStateProvider) {
    _currentSportId = _sportProvider.id;

    // Special handlers for sport changes vs general home state changes
    _sportProvider.addListener(_onSportChanged);
    _homeStateProvider.addListener(_onHomeStateChanged);

    // Don't trigger refresh in constructor, wait for dependencies to initialize
    _isInitializing = true;

    // Schedule initialization after the current frame with a 1-second delay
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for 1 second before initializing to avoid race conditions
      await Future.delayed(Duration(seconds: 1));
      _isInitializing = false;
      refreshData();
    });
  }

  // Handler for sport changes (high priority)
  void _onSportChanged() {
    if (_currentSportId != _sportProvider.id) {
      log('Sport changed from ${Sport.values[_currentSportId]} to ${_sportProvider.self}, refreshing data');
      _currentSportId = _sportProvider.id;
      refreshData(immediate: true);
    }
  }

  // Handler for home state changes (can be debounced)
  void _onHomeStateChanged() {
    refreshData(immediate: true);
  }

  Future<void> refreshData({
    bool immediate = false
  }) async {
    // Cancel any existing debounce timer
    if (_debounceTimer?.isActive ?? false) {
      log('Cancelling previous debounce timer');
      _debounceTimer!.cancel();
    }

    // For immediate refreshes, execute immediately
    if (immediate) {
      await _executeRefresh();
      return;
    }

    // For regular refreshes, use debounce to prevent duplicate calls
    _debounceTimer = Timer(Duration(milliseconds: debounceDuration), () {
      _executeRefresh();
    });
  }

  // The actual refresh implementation
  Future<void> _executeRefresh() async {
    // If a refresh is already in progress and this is not a high-priority refresh,
    // wait for the current refresh to complete instead of starting a new one
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      log('Refresh already in progress, waiting to complete');
      await _refreshCompleter!.future;
      return;
    }

    // Create a new completer to track this refresh operation
    _refreshCompleter = Completer<void>();

    // Update loading state
    teammatePagingState = teammatePagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // Clear existing items
      teammatePagingState.items?.clear();
      final newKey = 1;

      // Fetch data from database (simulated)
      await Future.delayed(Duration(milliseconds: 500));
      final List<TeammateModel> freshTeammates = [];
      final isLastPage = freshTeammates.isEmpty;

      // Update state with new data
      teammatePagingState = teammatePagingState.copyWith(
        pages: [freshTeammates],
        keys: [...?teammatePagingState.keys, newKey],
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
      _refreshCompleter!.complete();
    }
  }

  Future<void> loadTeammate() async {

    // Don't load more if a refresh is already in progress
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      log('Refresh in progress, skipping load more');
      return;
    }

    // Don't start loading if we're already loading
    if (teammatePagingState.isLoading) {
      log('Already loading, skipping duplicate load request');
      return;
    }

    log('Loading more teammates for sport: ${_sportProvider.self}');

    // Update loading state
    teammatePagingState = teammatePagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // Store current sport ID to detect changes during fetch
      final requestedSportId = _sportProvider.id;

      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Calculate next page key and fetch next page of data
      final newKey = (teammatePagingState.keys?.last ?? 0) + 1;
      final List<TeammateModel> nextTeammates = [];

      // Update state with new page data
      teammatePagingState = teammatePagingState.copyWith(
        pages: [...?teammatePagingState.pages, nextTeammates],
        keys: [...?teammatePagingState.keys, newKey],
        hasNextPage: false,
        isLoading: false,
      );
    } catch (exception, stackTrace) {
      // Log error to Sentry and update state
      Sentry.captureException(exception, stackTrace: stackTrace);
      teammatePagingState = teammatePagingState.copyWith(
          isLoading: false, error: genericErrorMessage);
    } finally {
      // Always notify listeners
      notifyListeners();
    }
  }

  void updateDependencies(SelectedSportProvider sportProvider, HomeStateProvider homeStateProvider) {
    if (_sportProvider != sportProvider || _homeStateProvider != homeStateProvider) {
      // Remove listeners from old providers
      _sportProvider.removeListener(_onSportChanged);
      _homeStateProvider.removeListener(_onHomeStateChanged);

      // Check if sport changed
      final sportChanged = _currentSportId != sportProvider.id;

      // Update references
      _sportProvider = sportProvider;
      _homeStateProvider = homeStateProvider;
      _currentSportId = sportProvider.id;

      // Add listeners to new providers
      _sportProvider.addListener(_onSportChanged);
      _homeStateProvider.addListener(_onHomeStateChanged);

      // Refresh data with new dependencies
      refreshData(immediate: sportChanged);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _sportProvider.removeListener(_onSportChanged);
    _homeStateProvider.removeListener(_onHomeStateChanged);
    super.dispose();
  }
}
