// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      type: $enumDecode(_$AppointmentTypeEnumMap, json['type']),
      location: json['location'] as String?,
      status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
      professionalId: json['professionalId'] as String?,
      professionalName: json['professionalName'] as String?,
      professionalAvatar: json['professionalAvatar'] as String?,
      lobbyId: json['lobbyId'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'type': _$AppointmentTypeEnumMap[instance.type]!,
      if (instance.location case final value?) 'location': value,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      if (instance.professionalId case final value?) 'professionalId': value,
      if (instance.professionalName case final value?)
        'professionalName': value,
      if (instance.professionalAvatar case final value?)
        'professionalAvatar': value,
      if (instance.lobbyId case final value?) 'lobbyId': value,
      if (instance.participants case final value?) 'participants': value,
    };

const _$AppointmentTypeEnumMap = {
  AppointmentType.professionalBooking: 'professional_booking',
  AppointmentType.playSession: 'play_session',
  AppointmentType.tournament: 'tournament',
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pending: 'pending',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.completed: 'completed',
};

UserLobbyModel _$UserLobbyModelFromJson(Map<String, dynamic> json) =>
    UserLobbyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
      status: $enumDecode(_$LobbyStatusEnumMap, json['status']),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentParticipants: (json['currentParticipants'] as num).toInt(),
      sportId: json['sportId'] as String,
      location: json['location'] as String?,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserLobbyModelToJson(UserLobbyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      if (instance.scheduledTime?.toIso8601String() case final value?)
        'scheduledTime': value,
      'status': _$LobbyStatusEnumMap[instance.status]!,
      'maxParticipants': instance.maxParticipants,
      'currentParticipants': instance.currentParticipants,
      'sportId': instance.sportId,
      if (instance.location case final value?) 'location': value,
      'participantIds': instance.participantIds,
      if (instance.metadata case final value?) 'metadata': value,
    };

const _$LobbyStatusEnumMap = {
  LobbyStatus.active: 'active',
  LobbyStatus.scheduled: 'scheduled',
  LobbyStatus.full: 'full',
  LobbyStatus.cancelled: 'cancelled',
  LobbyStatus.completed: 'completed',
};
