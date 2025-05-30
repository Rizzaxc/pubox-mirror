// lib/profile/user_details.dart
import 'package:json_annotation/json_annotation.dart';

import 'enum.dart';
import 'timeslot.dart';

part 'user_details.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDetails {
  @JsonKey(name: 'gender')
  String? gender;

  @JsonKey(name: 'age_group')
  AgeGroup? ageGroup;

  @JsonKey(name: 'playtime')
  List<Timeslot>? playtime;

  @JsonKey(name: 'location')
  UserLocation? location;

  @JsonKey(name: 'sport')
  UserSportProfile? sport;

  UserDetails({
    this.playtime,
    this.location,
    this.sport,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserLocation {
  @JsonKey(name: 'city')
  City? city;

  @JsonKey(name: 'districts')
  List<String>? districts;

  UserLocation({
    this.city,
    this.districts,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserSportProfile {
  @JsonKey(name: '1')
  SoccerProfile? soccer;

  @JsonKey(name: '2')
  BasketballProfile? basketball;

  @JsonKey(name: '3')
  BadmintonProfile? badminton;

  @JsonKey(name: '4')
  TennisProfile? tennis;

  @JsonKey(name: '5')
  PickleballProfile? pickleball;

  UserSportProfile({
    this.soccer,
    this.basketball,
    this.badminton,
    this.tennis,
    this.pickleball,
  });

  factory UserSportProfile.fromJson(Map<String, dynamic> json) =>
      _$UserSportProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserSportProfileToJson(this);
}

@JsonSerializable()
class SoccerProfile {
  @JsonKey(name: 'skill')
  int? skill;

  SoccerProfile({this.skill});

  factory SoccerProfile.fromJson(Map<String, dynamic> json) =>
      _$SoccerProfileFromJson(json);

  Map<String, dynamic> toJson() => _$SoccerProfileToJson(this);
}

@JsonSerializable()
class BasketballProfile {
  @JsonKey(name: 'skill')
  int? skill;

  BasketballProfile({this.skill});

  factory BasketballProfile.fromJson(Map<String, dynamic> json) =>
      _$BasketballProfileFromJson(json);

  Map<String, dynamic> toJson() => _$BasketballProfileToJson(this);
}

@JsonSerializable()
class BadmintonProfile {
  @JsonKey(name: 'skill')
  int? skill;

  BadmintonProfile({this.skill});

  factory BadmintonProfile.fromJson(Map<String, dynamic> json) =>
      _$BadmintonProfileFromJson(json);

  Map<String, dynamic> toJson() => _$BadmintonProfileToJson(this);
}

@JsonSerializable()
class TennisProfile {
  @JsonKey(name: 'skill')
  int? skill;

  TennisProfile({this.skill});

  factory TennisProfile.fromJson(Map<String, dynamic> json) =>
      _$TennisProfileFromJson(json);

  Map<String, dynamic> toJson() => _$TennisProfileToJson(this);
}

@JsonSerializable()
class PickleballProfile {
  @JsonKey(name: 'skill')
  int? skill;

  PickleballProfile({this.skill});

  factory PickleballProfile.fromJson(Map<String, dynamic> json) =>
      _$PickleballProfileFromJson(json);

  Map<String, dynamic> toJson() => _$PickleballProfileToJson(this);
}
