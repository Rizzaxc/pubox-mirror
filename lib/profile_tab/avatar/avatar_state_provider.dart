import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/user_preferences.dart';

/// A manager class that handles avatar generation and image uploads
class AvatarStateProvider extends ChangeNotifier {
  static final AvatarStateProvider _instance = AvatarStateProvider._internal();

  // Keys for SharedPreferences
  static const String _seedKey = 'avatar_seed';
  static const String _imagePathKey = 'avatar_image_path';

  factory AvatarStateProvider() {
    return _instance;
  }

  AvatarStateProvider._internal();

  final Random _random = Random();
  String _currentSeed = '';
  String? _imagePath;
  bool _isLoading = false;

  /// Get the current seed string used for avatar generation
  String get currentSeed => _currentSeed;

  /// Get the path to the user's uploaded image, if any
  String? get imagePath => _imagePath;

  /// Check if an image is currently being loaded
  bool get isLoading => _isLoading;

  /// Check if the user has uploaded an image
  bool get hasCustomImage => _imagePath != null;

  /// Initialize the manager with a base string and load any saved data
  Future<void> initialize(String baseString) async {
    // Load saved seed from shared preferences
    await _loadSeed();

    // If no seed was loaded, use the provided base string
    if (_currentSeed.isEmpty) {
      _currentSeed = baseString;
      await _saveSeed();
    }

    // Load saved image path from shared preferences
    await _loadImagePath();

    notifyListeners();
  }

  /// Generate a new random seed based on the original string
  Future<void> generateNewSeed(String baseString) async {
    // Create a list of characters from the base string
    List<String> chars = baseString.split('');

    // Shuffle the characters
    chars.shuffle(_random);

    // Add some random characters to make it more unique
    const randomChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    for (int i = 0; i < 3; i++) {
      chars.add(randomChars[_random.nextInt(randomChars.length)]);
    }

    // Shuffle again
    chars.shuffle(_random);

    // Create the new seed
    _currentSeed = chars.join('');

    // Save the new seed to shared preferences
    await _saveSeed();

    // Notify listeners about the change
    notifyListeners();
  }

  /// Set the path to the user's uploaded image
  Future<void> setImagePath(String path) async {
    _isLoading = true;
    notifyListeners();

    _imagePath = path;

    // Save the image path to shared preferences
    await _saveImagePath();

    _isLoading = false;
    notifyListeners();
  }

  /// Clear the user's uploaded image
  Future<void> clearImage() async {
    _isLoading = true;
    notifyListeners();

    _imagePath = null;

    // Remove the image path from shared preferences
    await _removeImagePath();

    _isLoading = false;
    notifyListeners();
  }

  /// Load the image path and seed from shared preferences
  Future<void> _loadImagePath() async {
    final prefs = UserPreferences.instance;
    _imagePath = await prefs.getString(_imagePathKey);

    // Verify that the file still exists
    if (_imagePath != null) {
      final file = File(_imagePath!);
      if (!await file.exists()) {
        _imagePath = null;
        await _removeImagePath();
      }
    }
  }

  /// Load the seed from shared preferences
  Future<void> _loadSeed() async {
    final prefs = UserPreferences.instance;
    final savedSeed = await prefs.getString(_seedKey);
    if (savedSeed != null && savedSeed.isNotEmpty) {
      _currentSeed = savedSeed;
    }
  }

  /// Save the image path to shared preferences
  Future<void> _saveImagePath() async {
    final prefs = UserPreferences.instance;
    if (_imagePath != null) {
      await prefs.setString(_imagePathKey, _imagePath!);
    }
  }

  /// Save the seed to shared preferences
  Future<void> _saveSeed() async {
    final prefs = UserPreferences.instance;
    await prefs.setString(_seedKey, _currentSeed);
  }

  /// Remove the image path from shared preferences
  Future<void> _removeImagePath() async {
    final prefs = UserPreferences.instance;
    await prefs.remove(_imagePathKey);
  }

  /// Remove the seed from shared preferences
  Future<void> _removeSeed() async {
    final prefs = UserPreferences.instance;
    await prefs.remove(_seedKey);
  }
}
