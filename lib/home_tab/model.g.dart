// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeammateModel _$TeammateModelFromJson(Map<String, dynamic> json) =>
    TeammateModel(
      teammateResultType:
          $enumDecode(_$TeammateResultTypeEnumMap, json['teammateResultType']),
      resultTitle: json['resultTitle'] as String,
      location:
          (json['location'] as List<dynamic>).map((e) => e as String).toList(),
      playtime: Timeslot.fromJson(json['playtime'] as Map<String, dynamic>),
      details: json['details'],
      compatScore: (json['compatScore'] as num).toDouble(),
      searchableId: json['searchableId'] as String,
    );

Map<String, dynamic> _$TeammateModelToJson(TeammateModel instance) =>
    <String, dynamic>{
      'teammateResultType':
          _$TeammateResultTypeEnumMap[instance.teammateResultType]!,
      'resultTitle': instance.resultTitle,
      'location': instance.location,
      'playtime': instance.playtime.toJson(),
      if (instance.details case final value?) 'details': value,
      'compatScore': instance.compatScore,
      'searchableId': instance.searchableId,
    };

const _$TeammateResultTypeEnumMap = {
  TeammateResultType.lobby: 'lobby',
  TeammateResultType.player: 'player',
};

ChallengerModel _$ChallengerModelFromJson(Map<String, dynamic> json) =>
    ChallengerModel(
      lobbyId: json['lobbyId'] as String,
      playtime: Timeslot.fromJson(json['playtime'] as Map<String, dynamic>),
      location: json['location'] as String,
      compatScore: (json['compatScore'] as num).toDouble(),
      fairplayScore: (json['fairplayScore'] as num).toDouble(),
      records: json['records'],
      stake: json['stake'],
      stakeUnit: $enumDecode(_$StakeUnitEnumMap, json['stakeUnit']),
    );

Map<String, dynamic> _$ChallengerModelToJson(ChallengerModel instance) =>
    <String, dynamic>{
      'lobbyId': instance.lobbyId,
      'playtime': instance.playtime.toJson(),
      'location': instance.location,
      'compatScore': instance.compatScore,
      'fairplayScore': instance.fairplayScore,
      if (instance.records case final value?) 'records': value,
      if (instance.stake case final value?) 'stake': value,
      'stakeUnit': _$StakeUnitEnumMap[instance.stakeUnit]!,
    };

const _$StakeUnitEnumMap = {
  StakeUnit.game: 'game',
  StakeUnit.set: 'set',
  StakeUnit.goal: 'goal',
};

NeutralModel _$NeutralModelFromJson(Map<String, dynamic> json) => NeutralModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NeutralModelToJson(NeutralModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };

ProfessionalModel _$ProfessionalModelFromJson(Map<String, dynamic> json) =>
    ProfessionalModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      bio: json['bio'] as String,
      role: $enumDecode(_$ProfessionalRoleEnumMap, json['role']),
      avatarUrl: json['avatarUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      experienceYears: (json['experienceYears'] as num).toInt(),
      isVerified: json['isVerified'] as bool,
      isAvailable: json['isAvailable'] as bool,
      services: (json['services'] as List<dynamic>)
          .map((e) => ProfessionalService.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProfessionalModelToJson(ProfessionalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'role': _$ProfessionalRoleEnumMap[instance.role]!,
      if (instance.avatarUrl case final value?) 'avatarUrl': value,
      if (instance.rating case final value?) 'rating': value,
      'reviewCount': instance.reviewCount,
      'experienceYears': instance.experienceYears,
      'isVerified': instance.isVerified,
      'isAvailable': instance.isAvailable,
      'services': instance.services.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ProfessionalRoleEnumMap = {
  ProfessionalRole.coach: 'coach',
  ProfessionalRole.referee: 'referee',
};

ProfessionalService _$ProfessionalServiceFromJson(Map<String, dynamic> json) =>
    ProfessionalService(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ProfessionalServiceToJson(
        ProfessionalService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'durationMinutes': instance.durationMinutes,
      'isActive': instance.isActive,
    };
