// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player()
  ..id = json['id'] as String?
  ..username = json['username'] as String? ?? 'Guest'
  ..tagNumber = json['tagNumber'] as String? ?? '0000';

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'tagNumber': instance.tagNumber,
    };
