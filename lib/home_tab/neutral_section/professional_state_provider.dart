import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/logger.dart';
import '../../core/sport_switcher.dart';
import '../../core/utils.dart';
import '../state_provider.dart';
import '../model.dart';

class ProfessionalStateProvider with ChangeNotifier {
  static const int _pageSize = 10;
  
  final HomeStateProvider _homeStateProvider;
  final SelectedSportProvider _sportProvider;
  
  bool get isInitialized =>
      _homeStateProvider.isInitialized && _sportProvider.isInitialized;
  
  // Professional data
  PagingState<int, ProfessionalModel> professionalPagingState = PagingState();
  
  // Filter state
  ProfessionalRole? _selectedRole;
  
  // Wrapper for the execute function
  CancelableOperation<List<ProfessionalModel>>? _cancelableExecuteLoad;
  
  // Getters
  ProfessionalRole? get selectedRole => _selectedRole;
  
  ProfessionalStateProvider(this._homeStateProvider, this._sportProvider) {
    _homeStateProvider.addListener(_onDependenciesChanged);
    _sportProvider.addListener(_onDependenciesChanged);
  }

  @override
  void dispose() {
    _homeStateProvider.removeListener(_onDependenciesChanged);
    _sportProvider.removeListener(_onDependenciesChanged);
    super.dispose();
  }

  void _onDependenciesChanged() {
    if (!isInitialized) return;
    loadData(isRefresh: true);
  }

  /// Set role filter and refresh results
  void setRoleFilter(ProfessionalRole? role) {
    _selectedRole = role;
    notifyListeners();
    loadData(isRefresh: true);
  }

  /// Refresh the entire list
  void refresh() {
    loadData(isRefresh: true);
  }

  Future<void> loadData({bool isRefresh = false}) async {
    AppLogger.d('loading professional data. isRefresh $isRefresh sport ${_sportProvider.self} isInitialized $isInitialized');
    if (!isInitialized) return;

    // If not a complete refresh and a request is already fired
    if (!isRefresh && professionalPagingState.isLoading) return;

    // If force refresh, cancel any existing request
    if (isRefresh) {
      _cancelableExecuteLoad?.cancel();
      _cancelableExecuteLoad = null;
    }

    // Update loading state
    professionalPagingState =
        professionalPagingState.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      // Clear existing items if refresh, else progress the key
      final newKey =
          isRefresh ? 1 : ((professionalPagingState.keys?.last ?? 0) + 1);

      _cancelableExecuteLoad = CancelableOperation.fromFuture(
        _fetchProfessionals(offset: 0, limit: _pageSize), onCancel: () {}
      );

      final List<ProfessionalModel> data = await _cancelableExecuteLoad?.value ?? [];
      final isLastPage = data.isEmpty;

      // Update state with new data
      professionalPagingState = professionalPagingState.copyWith(
        pages: isRefresh ? [data] : [...?professionalPagingState.pages, data],
        keys: isRefresh ? [newKey] : [...?professionalPagingState.keys, newKey],
        hasNextPage: !isLastPage,
        isLoading: false,
      );
    } catch (exception, stackTrace) {
      // Log error to Sentry and update state
      Sentry.captureException(exception, stackTrace: stackTrace);
      professionalPagingState = professionalPagingState.copyWith(
          isLoading: false, error: genericErrorMessage);
    } finally {
      // Always notify listeners and complete the operation
      notifyListeners();
    }
  }

  /// Fetch professionals from database
  Future<List<ProfessionalModel>> _fetchProfessionals({
    required int offset,
    required int limit,
  }) async {
    try {
      // Build query parameters
      final params = <String, dynamic>{
        'sport_id': _sportProvider.id, // Sport enum to ID
        'offset_count': offset,
        'limit_count': limit,
      };

      // Add location filter if available
      // if (_homeStateProvider.city) {
      //   params['location_id'] = _homeStateProvider.selectedLocation!.id;
      // }

      // Add role filter if selected
      if (_selectedRole != null) {
        params['role_filter'] = _selectedRole!.name;
      }

      // Add timeslot filter if available
      // if (_homeStateProvider.selectedTimeslots.isNotEmpty) {
      //   params['timeslots'] = _homeStateProvider.selectedTimeslots
      //       .map((slot) => slot.toJson())
      //       .toList();
      // }

      // Call database function
      final response = await supabase.rpc('get_professionals', params: params);
      
      if (response == null) return [];

      return (response as List)
          .map((json) => ProfessionalModel.fromJson(json))
          .toList();
    } catch (error, stackTrace) {
      AppLogger.d('Error fetching professionals: $error');
      Sentry.captureException(error, stackTrace: stackTrace);
      return [];
    }
  }

  /// Book a slot with a professional
  Future<bool> bookSlot({
    required int professionalId,
    required int serviceId,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) async {
    try {
      final response = await supabase.from('professional_booking').insert({
        'professional_id': professionalId,
        'service_id': serviceId,
        'user_id': supabase.auth.currentUser!.id,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'notes': notes,
        'status': 'pending',
      }).select().single();

      AppLogger.d('Booking created: ${response['id']}');
      return true;
    } catch (error, stackTrace) {
      AppLogger.d('Error creating booking: $error');
      Sentry.captureException(error, stackTrace: stackTrace);
      return false;
    }
  }

  /// Get available time slots for a professional
  Future<List<TimeSlot>> getAvailableSlots({
    required int professionalId,
    required DateTime date,
  }) async {
    try {
      final response = await supabase.rpc('get_professional_availability', params: {
        'professional_id': professionalId,
        'target_date': date.toIso8601String().split('T')[0], // Date only
      });

      if (response == null) return [];

      return (response as List)
          .map((json) => TimeSlot.fromJson(json))
          .toList();
    } catch (error, stackTrace) {
      AppLogger.d('Error fetching availability: $error');
      Sentry.captureException(error, stackTrace: stackTrace);
      return [];
    }
  }
}

/// Time slot model for booking
class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final double? price;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.price,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      isAvailable: json['is_available'] ?? true,
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_available': isAvailable,
      'price': price,
    };
  }
}