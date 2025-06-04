import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../core/model/enum.dart';
import '../core/model/user_details.dart';
import '../core/player_provider.dart';
import '../core/sport_switcher.dart';

class ProfileStateProvider extends ChangeNotifier {
  final PlayerProvider _playerProvider;
  final SelectedSportProvider _sportProvider;

  // Pending changes
  Gender? _pendingGender;
  AgeGroup? _pendingAgeGroup;
  int? _pendingSkill;
  int? _pendingFitness;
  String? _pendingPosition;

  bool _hasPendingChanges = false;

  ProfileStateProvider(this._playerProvider, this._sportProvider) {
    // Listen for changes in player data
    _playerProvider.addListener(notifyListeners);

    // Listen for changes in selected sport
    _sportProvider.addListener(notifyListeners);
  }

  // Getters for current values
  Gender? get gender => _pendingGender ?? _playerProvider.player.details?.gender;
  AgeGroup? get ageGroup => _pendingAgeGroup ?? _playerProvider.player.details?.ageGroup;

  int? get skill {
    if (_pendingSkill != null) return _pendingSkill;

    final details = _playerProvider.player.details;
    if (details?.sport == null) return null;

    switch (_sportProvider.id) {
      case 1: return details!.sport!.soccer?.skill;
      case 2: return details!.sport!.basketball?.skill;
      case 3: return details!.sport!.badminton?.skill;
      case 4: return details!.sport!.tennis?.skill;
      case 5: return details!.sport!.pickleball?.skill;
      default: return null;
    }
  }

  int? get fitness => _pendingFitness;
  String? get position => _pendingPosition;

  bool get hasPendingChanges => _hasPendingChanges;

  // Update methods
  void updateGender(Gender? newGender) {
    if (newGender == gender) return;
    _pendingGender = newGender;
    _hasPendingChanges = true;
    notifyListeners();
  }

  void updateAgeGroup(AgeGroup? newAgeGroup) {
    if (newAgeGroup == ageGroup) return;
    _pendingAgeGroup = newAgeGroup;
    _hasPendingChanges = true;
    notifyListeners();
  }

  void updateSkill(int? newSkill) {
    if (newSkill == skill) return;
    _pendingSkill = newSkill;
    _hasPendingChanges = true;
    notifyListeners();
  }

  void updateFitness(int? newFitness) {
    if (newFitness == fitness) return;
    _pendingFitness = newFitness;
    _hasPendingChanges = true;
    notifyListeners();
  }

  void updatePosition(String? newPosition) {
    if (newPosition == position) return;
    _pendingPosition = newPosition;
    _hasPendingChanges = true;
    notifyListeners();
  }

  // Commit changes to the player provider
  Future<void> commit() async {
    if (!_hasPendingChanges) return;

    // Get the current player details or create a new one if null
    final player = _playerProvider.player;
    final details = player.details ?? UserDetails();

    // Update gender if changed
    if (_pendingGender != null) {
      details.gender = _pendingGender;
      _pendingGender = null;
    }

    // Update age group if changed
    if (_pendingAgeGroup != null) {
      details.ageGroup = _pendingAgeGroup;
      _pendingAgeGroup = null;
    }

    // Update sport-specific details if changed
    final sportId = _sportProvider.id;

    // Ensure sport profile exists
    details.sport ??= UserSportProfile();

    // Update sport-specific details based on the selected sport
    switch (sportId) {
      case 1: // Soccer
        details.sport!.soccer ??= SoccerProfile();
        if (_pendingSkill != null) {
          details.sport!.soccer!.skill = _pendingSkill;
          _pendingSkill = null;
        }
        break;
      case 2: // Basketball
        details.sport!.basketball ??= BasketballProfile();
        if (_pendingSkill != null) {
          details.sport!.basketball!.skill = _pendingSkill;
          _pendingSkill = null;
        }
        break;
      case 3: // Badminton
        details.sport!.badminton ??= BadmintonProfile();
        if (_pendingSkill != null) {
          details.sport!.badminton!.skill = _pendingSkill;
          _pendingSkill = null;
        }
        break;
      case 4: // Tennis
        details.sport!.tennis ??= TennisProfile();
        if (_pendingSkill != null) {
          details.sport!.tennis!.skill = _pendingSkill;
          _pendingSkill = null;
        }
        break;
      case 5: // Pickleball
        details.sport!.pickleball ??= PickleballProfile();
        if (_pendingSkill != null) {
          details.sport!.pickleball!.skill = _pendingSkill;
          _pendingSkill = null;
        }
        break;
    }

    // Update the player details
    player.update(details: details);

    // TODO: Save to server

    _hasPendingChanges = false;
    notifyListeners();
  }

  // Discard pending changes
  void discardChanges() {
    _pendingGender = null;
    _pendingAgeGroup = null;
    _pendingSkill = null;
    _pendingFitness = null;
    _pendingPosition = null;

    _hasPendingChanges = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _playerProvider.removeListener(notifyListeners);
    _sportProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
