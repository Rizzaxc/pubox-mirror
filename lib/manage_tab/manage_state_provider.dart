import 'package:flutter/foundation.dart';
import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import 'lobby_section/lobby_state_provider.dart';
import 'schedule_section/schedule_state_provider.dart';

class ManageStateProvider extends ChangeNotifier {
  final PlayerProvider _playerProvider;
  final SelectedSportProvider _sportProvider;
  final LobbyStateProvider _lobbyStateProvider;
  final ScheduleStateProvider _scheduleStateProvider;

  bool _isLoading = false;
  String? _error;

  ManageStateProvider(
    this._playerProvider,
    this._sportProvider,
    this._lobbyStateProvider,
    this._scheduleStateProvider,
  ) {
    _playerProvider.addListener(notifyListeners);
    _sportProvider.addListener(_onSportChanged);
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  PlayerProvider get playerProvider => _playerProvider;
  SelectedSportProvider get sportProvider => _sportProvider;
  LobbyStateProvider get lobbyStateProvider => _lobbyStateProvider;
  ScheduleStateProvider get scheduleStateProvider => _scheduleStateProvider;

  // Called when the sport changes
  void _onSportChanged() {
    refreshData();
    notifyListeners();
  }

  // Start loading data
  void startLoading() {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    refreshData().then((_) {
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Refresh data from both lobby and schedule providers
  Future<void> refreshData() async {
    if (_playerProvider.id == null) return;
    
    try {
      await Future.wait([
        _lobbyStateProvider.loadLobbies(),
        _scheduleStateProvider.loadAppointments(),
      ]);
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  @override
  void dispose() {
    _playerProvider.removeListener(notifyListeners);
    _sportProvider.removeListener(_onSportChanged);
    super.dispose();
  }
}