// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      playtime: (json['playtime'] as List<dynamic>?)
          ?.map((e) => Timeslot.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] == null
          ? null
          : UserLocation.fromJson(json['location'] as Map<String, dynamic>),
      sport: json['sport'] == null
          ? null
          : UserSportProfile.fromJson(json['sport'] as Map<String, dynamic>),
    )
      ..gender = json['gender'] as String?
      ..ageGroup = $enumDecodeNullable(_$AgeGroupEnumMap, json['age_group']);

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'age_group': _$AgeGroupEnumMap[instance.ageGroup],
      'playtime': instance.playtime?.map((e) => e.toJson()).toList(),
      'location': instance.location?.toJson(),
      'sport': instance.sport?.toJson(),
    };

const _$AgeGroupEnumMap = {
  AgeGroup.student: 'student',
  AgeGroup.mature: 'mature',
  AgeGroup.middleAge: 'middle_age',
};

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
      city: $enumDecodeNullable(_$CityEnumMap, json['city']),
      districts: (json['districts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'city': _$CityEnumMap[instance.city],
      'districts': instance.districts,
    };

const _$CityEnumMap = {
  City.hochiminh: '1',
  City.hanoi: '2',
};

UserSportProfile _$UserSportProfileFromJson(Map<String, dynamic> json) =>
    UserSportProfile(
      soccer: json['1'] == null
          ? null
          : SoccerProfile.fromJson(json['1'] as Map<String, dynamic>),
      basketball: json['2'] == null
          ? null
          : BasketballProfile.fromJson(json['2'] as Map<String, dynamic>),
      badminton: json['3'] == null
          ? null
          : BadmintonProfile.fromJson(json['3'] as Map<String, dynamic>),
      tennis: json['4'] == null
          ? null
          : TennisProfile.fromJson(json['4'] as Map<String, dynamic>),
      pickleball: json['5'] == null
          ? null
          : PickleballProfile.fromJson(json['5'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserSportProfileToJson(UserSportProfile instance) =>
    <String, dynamic>{
      '1': instance.soccer?.toJson(),
      '2': instance.basketball?.toJson(),
      '3': instance.badminton?.toJson(),
      '4': instance.tennis?.toJson(),
      '5': instance.pickleball?.toJson(),
    };

SoccerProfile _$SoccerProfileFromJson(Map<String, dynamic> json) =>
    SoccerProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SoccerProfileToJson(SoccerProfile instance) =>
    <String, dynamic>{
      'skill': instance.skill,
    };

BasketballProfile _$BasketballProfileFromJson(Map<String, dynamic> json) =>
    BasketballProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BasketballProfileToJson(BasketballProfile instance) =>
    <String, dynamic>{
      'skill': instance.skill,
    };

BadmintonProfile _$BadmintonProfileFromJson(Map<String, dynamic> json) =>
    BadmintonProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BadmintonProfileToJson(BadmintonProfile instance) =>
    <String, dynamic>{
      'skill': instance.skill,
    };

TennisProfile _$TennisProfileFromJson(Map<String, dynamic> json) =>
    TennisProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TennisProfileToJson(TennisProfile instance) =>
    <String, dynamic>{
      'skill': instance.skill,
    };

PickleballProfile _$PickleballProfileFromJson(Map<String, dynamic> json) =>
    PickleballProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PickleballProfileToJson(PickleballProfile instance) =>
    <String, dynamic>{
      'skill': instance.skill,
    };
