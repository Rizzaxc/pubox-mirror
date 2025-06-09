import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/logger.dart';
import '../core/model/enum.dart';
import '../core/model/user_details.dart';
import '../core/player_provider.dart';
import '../core/sport_switcher.dart';
import '../core/utils.dart';

class ProfileStateProvider extends ChangeNotifier {
  final PlayerProvider _playerProvider;
  final SelectedSportProvider _sportProvider;

  // Pending changes
  Gender? _pendingGender;
  AgeGroup? _pendingAgeGroup;
  List<Industry>? _pendingIndustries;

  // Available industries
  bool _loadingIndustries = false;

  // User's selected industries
  List<Industry> _selectedIndustries = [];
  bool _loadingSelectedIndustries = false;

  bool _hasPendingChanges = false;

  ProfileStateProvider(this._playerProvider, this._sportProvider) {
    _playerProvider.addListener(notifyListeners);
    _sportProvider.addListener(notifyListeners);

    // Initialize data
    _fetchUserIndustries();
    // TODO: _fetchUserNetworks();
  }

  // Fetch user's selected industries
  Future<void> _fetchUserIndustries() async {
    final player = _playerProvider.player;
    if (player.id == null || _loadingSelectedIndustries) return;

    _loadingSelectedIndustries = true;
    notifyListeners();

    try {
      final response = await supabase
          .from('user_industry')
          .select('industry_id')
          .eq('user_id', player.id!);

      AppLogger.d(response.toString());

      _selectedIndustries = (response as List).map((each) {
        return each as Industry;
      }).toList();
    } catch (e, stackTrace) {
      AppLogger.d('Error fetching selected industries: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      _loadingSelectedIndustries = false;
      notifyListeners();
    }
  }

  // Getters for current values
  Gender? get gender =>
      _pendingGender ?? _playerProvider.player.details?.gender;

  AgeGroup? get ageGroup =>
      _pendingAgeGroup ?? _playerProvider.player.details?.ageGroup;

  // Industry getters

  bool get loadingIndustries => _loadingIndustries;

  List<Industry> get selectedIndustries =>
      _pendingIndustries ?? _selectedIndustries;

  bool get loadingSelectedIndustries => _loadingSelectedIndustries;

  // int? get skill {
  //   if (_pendingSkill != null) return _pendingSkill;
  //
  //   final details = _playerProvider.player.details;
  //   if (details?.sport == null) return null;
  //
  //   switch (_sportProvider.id) {
  //     case 1:
  //       return details!.sport!.soccer?.skill;
  //     case 2:
  //       return details!.sport!.basketball?.skill;
  //     case 3:
  //       return details!.sport!.badminton?.skill;
  //     case 4:
  //       return details!.sport!.tennis?.skill;
  //     case 5:
  //       return details!.sport!.pickleball?.skill;
  //     default:
  //       return null;
  //   }
  // }

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

  // Add or remove a single industry
  void toggleIndustry(Industry industry) {
    _hasPendingChanges = true;
    _pendingIndustries ??= List.from(_selectedIndustries);

    // Check if the industry is already selected
    final selected = _pendingIndustries!.contains(industry);

    if (selected) {
      // Remove the industry
      _pendingIndustries = [..._pendingIndustries!];
      _pendingIndustries!.remove(industry);

    } else {
      // Add the industry if we haven't reached the limit
      if (_pendingIndustries!.length < 2) {
        _pendingIndustries = [..._pendingIndustries!, industry];
      } else {
        // Replace the first industry if we've reached the limit
        _pendingIndustries = [..._pendingIndustries!];
        _pendingIndustries![0] = _pendingIndustries![1];
        _pendingIndustries![1] = industry;

      }
    }
    notifyListeners();
  }

  // Commit changes to the player provider
  Future<bool> commitChanges() async {
    if (!_hasPendingChanges) return true;

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
    // switch (sportId) {
    //   case 1: // Soccer
    //     details.sport!.soccer ??= SoccerProfile();
    //     if (_pendingSkill != null) {
    //       details.sport!.soccer!.skill = _pendingSkill;
    //       _pendingSkill = null;
    //     }
    //     break;
    //   case 2: // Basketball
    //     details.sport!.basketball ??= BasketballProfile();
    //     if (_pendingSkill != null) {
    //       details.sport!.basketball!.skill = _pendingSkill;
    //       _pendingSkill = null;
    //     }
    //     break;
    //   case 3: // Badminton
    //     details.sport!.badminton ??= BadmintonProfile();
    //     if (_pendingSkill != null) {
    //       details.sport!.badminton!.skill = _pendingSkill;
    //       _pendingSkill = null;
    //     }
    //     break;
    //   case 4: // Tennis
    //     details.sport!.tennis ??= TennisProfile();
    //     if (_pendingSkill != null) {
    //       details.sport!.tennis!.skill = _pendingSkill;
    //       _pendingSkill = null;
    //     }
    //     break;
    //   case 5: // Pickleball
    //     details.sport!.pickleball ??= PickleballProfile();
    //     if (_pendingSkill != null) {
    //       details.sport!.pickleball!.skill = _pendingSkill;
    //       _pendingSkill = null;
    //     }
    //     break;
    // }

    try {
      final detailsMap = details.toJson();

      AppLogger.d(jsonEncode(details));

      // Send changes to server
      await supabase
          .from('user')
          .update({'details': detailsMap}).eq('id', player.id!);

      // Update the player details
      player.update(details: details);

      // Update industries if changed
      if (_pendingIndustries != null && _pendingIndustries != _selectedIndustries) {
        AppLogger.d(_pendingIndustries.toString());

        // First, delete all existing user_industry entries for this user
        await supabase.from('user_industry').delete().eq('user_id', player.id!);

        final data =
            _pendingIndustries!.map((industry) => {'user_id': player.id!, 'industry_id': industry.index}).toList();
        await supabase.from('user_industry').insert(data);

        // Update local state
        _selectedIndustries = List.from(_pendingIndustries!);
        _pendingIndustries = null;
      }

      _hasPendingChanges = false;
      notifyListeners();
      return true;
    } on PostgrestException catch (exception, stackTrace) {
      AppLogger.d(exception.message);
      Sentry.captureException(exception, stackTrace: stackTrace);
      discardChanges();
      return false;
    }
  }

  // Discard pending changes
  void discardChanges() {
    _pendingGender = null;
    _pendingAgeGroup = null;
    _pendingIndustries = null;

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
