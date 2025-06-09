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
      ..gender = $enumDecodeNullable(_$GenderEnumMap, json['gender'])
      ..ageGroup = $enumDecodeNullable(_$AgeGroupEnumMap, json['age_group']);

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      if (_$GenderEnumMap[instance.gender] case final value?) 'gender': value,
      if (_$AgeGroupEnumMap[instance.ageGroup] case final value?)
        'age_group': value,
      if (instance.playtime?.map((e) => e.toJson()).toList() case final value?)
        'playtime': value,
      if (instance.location?.toJson() case final value?) 'location': value,
      if (instance.sport?.toJson() case final value?) 'sport': value,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
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
      if (_$CityEnumMap[instance.city] case final value?) 'city': value,
      if (instance.districts case final value?) 'districts': value,
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
      if (instance.soccer?.toJson() case final value?) '1': value,
      if (instance.basketball?.toJson() case final value?) '2': value,
      if (instance.badminton?.toJson() case final value?) '3': value,
      if (instance.tennis?.toJson() case final value?) '4': value,
      if (instance.pickleball?.toJson() case final value?) '5': value,
    };

SoccerProfile _$SoccerProfileFromJson(Map<String, dynamic> json) =>
    SoccerProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SoccerProfileToJson(SoccerProfile instance) =>
    <String, dynamic>{
      if (instance.skill case final value?) 'skill': value,
    };

BasketballProfile _$BasketballProfileFromJson(Map<String, dynamic> json) =>
    BasketballProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BasketballProfileToJson(BasketballProfile instance) =>
    <String, dynamic>{
      if (instance.skill case final value?) 'skill': value,
    };

BadmintonProfile _$BadmintonProfileFromJson(Map<String, dynamic> json) =>
    BadmintonProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BadmintonProfileToJson(BadmintonProfile instance) =>
    <String, dynamic>{
      if (instance.skill case final value?) 'skill': value,
    };

TennisProfile _$TennisProfileFromJson(Map<String, dynamic> json) =>
    TennisProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TennisProfileToJson(TennisProfile instance) =>
    <String, dynamic>{
      if (instance.skill case final value?) 'skill': value,
    };

PickleballProfile _$PickleballProfileFromJson(Map<String, dynamic> json) =>
    PickleballProfile(
      skill: (json['skill'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PickleballProfileToJson(PickleballProfile instance) =>
    <String, dynamic>{
      if (instance.skill case final value?) 'skill': value,
    };
