import 'package:json_annotation/json_annotation.dart';

import 'user_details.dart';

part 'player.g.dart';

@JsonSerializable(explicitToJson: true)
class Player {
  static const defaultUsername = 'Guest';
  static const defaultTagNumber = '0000';

  // Private constructor for the singleton
  Player._({
    this.id,
    this.username = defaultUsername,
    this.tagNumber = defaultTagNumber,
    this.details,
  });

  // Singleton instance
  static Player _instance = Player._();

  // Getter for the instance
  // This allows modification of the instance's properties after initial creation.
  static Player get instance => _instance;

  // Method to update the singleton instance, typically used after deserialization
  static void _updateInstance(Player newInstance) {
    _instance = newInstance;
  }

  String? id;

  @JsonKey(defaultValue: defaultUsername)
  String username;

  @JsonKey(defaultValue: defaultTagNumber)
  String tagNumber;

  @JsonKey(name: 'details') // This will be the key in the JSON
  UserDetails? details;

  factory Player() => _instance;

  /// Connect the generated [_$PlayerFromJson] function to the `fromJson`
  /// factory.
  factory Player.fromJson(Map<String, dynamic> json) {
    final player = _$PlayerFromJson(json);
    // Update the singleton instance with the deserialized data
    // This ensures that Player.instance refers to the latest deserialized state.
    // However, be cautious with this approach in a complex app,
    // as it globally changes the Player instance.
    _updateInstance(player);
    return _instance;
  }

  /// Connect the generated [_$PlayerToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  // Method to update player properties, preserving the singleton nature
  void update({
    String? id,
    String? username,
    String? tagNumber,
    UserDetails? details,
  }) {
    if (id != null) _instance.id = id;
    if (username != null) _instance.username = username;
    if (tagNumber != null) _instance.tagNumber = tagNumber;
    if (details != null) _instance.details = details;
  }


}
