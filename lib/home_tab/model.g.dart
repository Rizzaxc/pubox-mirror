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
      'playtime': instance.playtime,
      'details': instance.details,
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
      'playtime': instance.playtime,
      'location': instance.location,
      'compatScore': instance.compatScore,
      'fairplayScore': instance.fairplayScore,
      'records': instance.records,
      'stake': instance.stake,
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
