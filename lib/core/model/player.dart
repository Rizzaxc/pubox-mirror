import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  Player._();
  // Singleton instance
  static final Player _instance = Player._();

  // Getter for the instance
  static Player get instance => _instance;

  static const defaultUsername = 'Guest';
  static const defaultTagNumber = '0000';

  String? id;
  @JsonKey(defaultValue: defaultUsername)
  String username = defaultUsername;
  @JsonKey(defaultValue: defaultTagNumber)
  String tagNumber = defaultTagNumber;

  factory Player() => _instance;

  /// Connect the generated [_$PlayerFromJson] function to the `fromJson`
  /// factory.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Connect the generated [_$PlayerToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
