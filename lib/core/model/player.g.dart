// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player()
  ..id = json['id'] as String?
  ..username = json['username'] as String? ?? 'Guest'
  ..tagNumber = json['tagNumber'] as String? ?? '0000'
  ..details = json['details'] == null
      ? null
      : UserDetails.fromJson(json['details'] as Map<String, dynamic>);

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'username': instance.username,
      'tagNumber': instance.tagNumber,
      if (instance.details?.toJson() case final value?) 'details': value,
    };
