import 'dart:async';

import 'package:flutter/foundation.dart';

import '../model.dart';

class ScheduleStateProvider with ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load appointments for the next 7 days
  Future<void> loadAppointments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      _appointments = _generateMockAppointments();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _appointments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh appointments
  Future<void> refresh() async {
    await loadAppointments();
  }

  /// Mock data generator for development
  List<AppointmentModel> _generateMockAppointments() {
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch;
    
    return [
      AppointmentModel(
        id: 'apt_1',
        title: 'Tennis Coaching Session',
        description: 'Private coaching session focusing on backhand techniques',
        startTime: now.add(const Duration(hours: 2)),
        endTime: now.add(const Duration(hours: 3)),
        type: AppointmentType.professionalBooking,
        status: AppointmentStatus.confirmed,
        location: 'Court 3, Tennis Center',
        professionalId: 'coach_1',
        professionalName: 'John Smith',
        professionalAvatar: null,
      ),
      AppointmentModel(
        id: 'apt_2',
        title: 'Mixed Doubles Match',
        description: 'Casual doubles match with friends',
        startTime: now.add(const Duration(days: 1, hours: 10)),
        endTime: now.add(const Duration(days: 1, hours: 12)),
        type: AppointmentType.playSession,
        status: AppointmentStatus.confirmed,
        location: 'Court 1, Community Center',
        participants: ['player_1', 'player_2', 'player_3'],
        lobbyId: 'lobby_1',
      ),
      AppointmentModel(
        id: 'apt_3',
        title: 'Weekend Tournament',
        description: 'Local tennis tournament - Quarter Finals',
        startTime: now.add(const Duration(days: 2, hours: 14)),
        endTime: now.add(const Duration(days: 2, hours: 16)),
        type: AppointmentType.tournament,
        status: AppointmentStatus.pending,
        location: 'Main Stadium',
      ),
      AppointmentModel(
        id: 'apt_4',
        title: 'Group Training',
        description: 'Advanced technique training with multiple players',
        startTime: now.add(const Duration(days: 3, hours: 16)),
        endTime: now.add(const Duration(days: 3, hours: 18)),
        type: AppointmentType.professionalBooking,
        status: AppointmentStatus.confirmed,
        location: 'Training Courts',
        professionalId: 'coach_2',
        professionalName: 'Sarah Johnson',
        participants: ['player_4', 'player_5', 'player_6'],
      ),
      AppointmentModel(
        id: 'apt_5',
        title: 'Singles Practice',
        description: 'Solo practice session',
        startTime: now.add(const Duration(days: 5, hours: 8)),
        endTime: now.add(const Duration(days: 5, hours: 9, minutes: 30)),
        type: AppointmentType.playSession,
        status: AppointmentStatus.confirmed,
        location: 'Practice Court A',
        lobbyId: 'lobby_2',
      ),
    ];
  }
}