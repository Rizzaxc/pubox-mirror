import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/model/enum.dart';
import '../model.dart';

class LobbyStateProvider with ChangeNotifier {
  List<UserLobbyModel> _lobbies = [];
  bool _isLoading = false;
  String? _error;
  String? _currentSportId;

  List<UserLobbyModel> get lobbies => _lobbies;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentSportId => _currentSportId;

  /// Load user's lobbies for the specified sport
  Future<void> loadLobbies() async {
    // if (_currentSportId == sportId && _lobbies.isNotEmpty) {
    //   // Already loaded for this sport
    //   return;
    // }
    //
    // _isLoading = true;
    // _error = null;
    // _currentSportId = sportId;
    // notifyListeners();
    //
    // try {
    //   // TODO: Replace with actual API call
    //   await Future.delayed(const Duration(seconds: 1));
    //
    //   _lobbies = _generateMockLobbies(sportId);
    //   _error = null;
    // } catch (e) {
    //   _error = e.toString();
    //   _lobbies = [];
    // } finally {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  /// Refresh lobbies for current sport
  Future<void> refresh() async {
    if (_currentSportId != null) {
      await loadLobbies();
    }
  }

  /// Mock data generator for development
  List<UserLobbyModel> _generateMockLobbies(String sportId) {
    final now = DateTime.now();
    
    // Generate different lobbies based on sport
    if (sportId == 'tennis') {
      return [
        UserLobbyModel(
          id: 'lobby_1',
          title: 'Weekend Singles Tournament',
          description: 'Competitive singles matches for intermediate players',
          createdAt: now.subtract(const Duration(days: 2)),
          scheduledTime: now.add(const Duration(days: 2, hours: 10)),
          status: LobbyStatus.active,
          maxParticipants: 8,
          currentParticipants: 6,
          sportId: sportId,
          location: 'Tennis Center Court 1-4',
          participantIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'],
        ),
        UserLobbyModel(
          id: 'lobby_2',
          title: 'Casual Doubles Match',
          description: 'Looking for 2 more players for doubles',
          createdAt: now.subtract(const Duration(hours: 3)),
          status: LobbyStatus.active,
          maxParticipants: 4,
          currentParticipants: 2,
          sportId: sportId,
          location: 'Community Court A',
          participantIds: ['p1', 'p2'],
        ),
        UserLobbyModel(
          id: 'lobby_3',
          title: 'Morning Practice Group',
          description: 'Early morning practice sessions - all levels welcome',
          createdAt: now.subtract(const Duration(days: 5)),
          scheduledTime: now.add(const Duration(days: 1, hours: 7)),
          status: LobbyStatus.full,
          maxParticipants: 6,
          currentParticipants: 6,
          sportId: sportId,
          location: 'Tennis Academy',
          participantIds: ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'],
        ),
        UserLobbyModel(
          id: 'lobby_4',
          title: 'Monthly Championship',
          description: 'Monthly championship series - Round 1',
          createdAt: now.subtract(const Duration(days: 10)),
          scheduledTime: now.add(const Duration(days: 7, hours: 14)),
          status: LobbyStatus.scheduled,
          maxParticipants: 16,
          currentParticipants: 12,
          sportId: sportId,
          location: 'Main Stadium',
          participantIds: List.generate(12, (i) => 'p${i + 1}'),
        ),
      ];
    } else if (sportId == 'badminton') {
      return [
        UserLobbyModel(
          id: 'lobby_b1',
          title: 'Mixed Doubles Session',
          description: 'Fun mixed doubles games',
          createdAt: now.subtract(const Duration(hours: 6)),
          status: LobbyStatus.active,
          maxParticipants: 8,
          currentParticipants: 4,
          sportId: sportId,
          location: 'Sports Hall B',
          participantIds: ['p1', 'p2', 'p3', 'p4'],
        ),
        UserLobbyModel(
          id: 'lobby_b2',
          title: 'Beginner Practice',
          description: 'Practice session for beginners',
          createdAt: now.subtract(const Duration(days: 1)),
          scheduledTime: now.add(const Duration(hours: 4)),
          status: LobbyStatus.scheduled,
          maxParticipants: 10,
          currentParticipants: 7,
          sportId: sportId,
          location: 'Community Center',
          participantIds: List.generate(7, (i) => 'p${i + 1}'),
        ),
      ];
    } else {
      // Default empty list for other sports
      return [];
    }
  }
}