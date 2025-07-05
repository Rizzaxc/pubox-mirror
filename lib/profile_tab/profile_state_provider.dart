import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/logger.dart';
import '../core/model/enum.dart';
import '../core/model/user_details.dart';
import '../core/model/timeslot.dart';
import '../core/network_repository.dart';
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
  List<Network>? _pendingNetworks;
  List<Timeslot>? _pendingPlaytime;

  // User's selected industries and networks
  List<Industry> _selectedIndustries = [];
  List<Network> _selectedNetworks = [];

  bool _hasPendingChanges = false;

  ProfileStateProvider(this._playerProvider, this._sportProvider) {
    _playerProvider.addListener(notifyListeners);
    _sportProvider.addListener(notifyListeners);

    // Initialize data
    _fetchUserIndustries();
    _fetchUserNetworks();
  }

  // Fetch user's selected industries
  Future<void> _fetchUserIndustries() async {
    if (_playerProvider.id == null) return;
    // if (player.id == null || _loadingSelectedIndustries) return;

    // _loadingSelectedIndustries = true;

    notifyListeners();

    try {
      final response = await supabase
          .from('user_industry')
          .select('industry_id')
          .eq('user_id', _playerProvider.id!);

      // AppLogger.d(response.toString());

      _selectedIndustries = (response as List).map((each) {
        return Industry.values[each['industry_id']];
      }).toList();
    } catch (e, stackTrace) {
      AppLogger.d('Error fetching selected industries: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      // _loadingSelectedIndustries = false;
      notifyListeners();
    }
  }

  // Fetch user's selected networks
  Future<void> _fetchUserNetworks() async {
    if (_playerProvider.id == null) return;

    notifyListeners();

    try {
      final response = await supabase
          .from('user_network')
          .select('network_id')
          .eq('user_id', _playerProvider.id!);

      // Convert the response to a list of Network objects
      _selectedNetworks = [];
      for (var each in response as List) {
        final networkId = each['network_id'];
        final network = await NetworkRepository.findNetworkById(networkId);
        if (network != null) {
          _selectedNetworks.add(network);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.d('Error fetching selected networks: $e');
      Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      notifyListeners();
    }
  }

  // Getters for current values
  Gender? get gender => _pendingGender ?? _playerProvider.details?.gender;

  AgeGroup? get ageGroup =>
      _pendingAgeGroup ?? _playerProvider.details?.ageGroup;

  // Playtime getter
  List<Timeslot>? get playtime =>
      _pendingPlaytime ?? _playerProvider.details?.playtime;

  // Industry getters
  List<Industry> get selectedIndustries =>
      _pendingIndustries ?? _selectedIndustries;

  // Network getters
  List<Network> get selectedNetworks => _pendingNetworks ?? _selectedNetworks;

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

  void updatePlaytime(List<Timeslot> newPlaytime) {
    if (newPlaytime == playtime) return;
    _pendingPlaytime = newPlaytime;
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

  void toggleAlumniStatus(Network network) {
    _hasPendingChanges = true;
    _pendingNetworks ??= List.from(_selectedNetworks);
    final updatedNetwork = Network(
        id: network.id,
        name: network.name,
        isAlumni: !(network.isAlumni),
        category: network.category);

    _pendingNetworks!.remove(network);
    _pendingNetworks!.add(updatedNetwork);
    _pendingNetworks = [..._pendingNetworks!];
    _pendingNetworks?.sort();

    notifyListeners();
  }

  // Add or remove a single network
  void toggleNetwork(Network network) {
    _hasPendingChanges = true;
    _pendingNetworks ??= List.from(_selectedNetworks);

    // Check if the network is already selected
    final selected = _pendingNetworks!.contains(network);

    if (selected) {
      // Remove the network
      _pendingNetworks = [..._pendingNetworks!];
      _pendingNetworks!.remove(network);
    } else {
      // Add the network if we haven't reached the limit
      if (_pendingNetworks!.length < 2) {
        _pendingNetworks = [..._pendingNetworks!, network];
      } else {
        // Replace the first network if we've reached the limit
        _pendingNetworks = [..._pendingNetworks!];
        _pendingNetworks![0] = _pendingNetworks![1];
        _pendingNetworks![1] = network;
      }
    }
    _pendingNetworks?.sort();
    notifyListeners();
  }

  // Method to update user data in Supabase
  Future<void> updateUserAccountData({
    String? username,
  }) async {
    // Update local state through provider
    _playerProvider.update(username: username);

    // TODO: Implement actual Supabase update
    // This is a stub for the actual implementation
    try {} catch (e) {}
  }

  // Commit changes to the player provider
  Future<bool> commitChanges() async {
    if (!_hasPendingChanges) return true;

    // Get the current player details or create a new one if null
    final details = _playerProvider.details ?? UserDetails();

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

    // Update playtime if changed
    if (_pendingPlaytime != null) {
      details.playtime = _pendingPlaytime;
      _pendingPlaytime = null;
    }

    try {
      final detailsMap = details.toJson();

      AppLogger.d(jsonEncode(details));

      // Send changes to server
      await supabase
          .from('user')
          .update({'details': detailsMap}).eq('id', _playerProvider.id!);

      // Update the player details
      _playerProvider.update(details: details);

      // Update industries if changed
      if (_pendingIndustries != null &&
          _pendingIndustries != _selectedIndustries) {
        AppLogger.d(_pendingIndustries.toString());

        // First, delete all existing user_industry entries for this user
        await supabase
            .from('user_industry')
            .delete()
            .eq('user_id', _playerProvider.id!);

        final data = _pendingIndustries!
            .map((industry) =>
                {'user_id': _playerProvider.id!, 'industry_id': industry.index})
            .toList();
        await supabase.from('user_industry').insert(data);

        // Update local state
        _selectedIndustries = List.from(_pendingIndustries!);
        _pendingIndustries = null;
      }

      // Update networks if changed
      if (_pendingNetworks != null && _pendingNetworks != _selectedNetworks) {
        AppLogger.d(_pendingNetworks.toString());

        // First, delete all existing user_network entries for this user
        await supabase
            .from('user_network')
            .delete()
            .eq('user_id', _playerProvider.id!);

        final data = _pendingNetworks!
            .map((network) =>
                {'user_id': _playerProvider.id!, 'network_id': network.id})
            .toList();
        await supabase.from('user_network').insert(data);

        // Update local state
        _selectedNetworks = List.from(_pendingNetworks!);
        _pendingNetworks = null;
      }

      notifyListeners();
      return true;
    } on PostgrestException catch (exception, stackTrace) {
      AppLogger.d(exception.message);
      Sentry.captureException(exception, stackTrace: stackTrace);
      discardChanges();
      return false;
    }
  }

  // Return whenever a part of the profile successfully refreshes
  // No need to notify since every submethod already notifies
  Future<void> refreshProfile() async {
    discardChanges(shouldNotify: false);
    try {
      await Future.any([
        _playerProvider.refreshData(),
        _fetchUserIndustries(),
        _fetchUserNetworks()
      ]);
    } on Exception catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  // Discard pending changes
  void discardChanges({bool shouldNotify = true}) {
    _pendingGender = null;
    _pendingAgeGroup = null;
    _pendingIndustries = null;
    _pendingNetworks = null;
    _pendingPlaytime = null;

    _hasPendingChanges = false;
    if (shouldNotify) notifyListeners();
  }

  @override
  void dispose() {
    _playerProvider.removeListener(notifyListeners);
    _sportProvider.removeListener(notifyListeners);
    super.dispose();
  }
}
