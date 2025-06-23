import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

/// Appointment model for schedule section
@JsonSerializable()
class AppointmentModel {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentType type;
  final String? location;
  final AppointmentStatus status;
  final String? professionalId;
  final String? professionalName;
  final String? professionalAvatar;
  final String? lobbyId;
  final List<String>? participants;

  const AppointmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.location,
    required this.status,
    this.professionalId,
    this.professionalName,
    this.professionalAvatar,
    this.lobbyId,
    this.participants,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}

/// User's lobby model for lobby section
@JsonSerializable()
class UserLobbyModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? scheduledTime;
  final LobbyStatus status;
  final int maxParticipants;
  final int currentParticipants;
  final String sportId;
  final String? location;
  final List<String> participantIds;
  final Map<String, dynamic>? metadata;

  const UserLobbyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.scheduledTime,
    required this.status,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.sportId,
    this.location,
    required this.participantIds,
    this.metadata,
  });

  factory UserLobbyModel.fromJson(Map<String, dynamic> json) =>
      _$UserLobbyModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLobbyModelToJson(this);
}

/// Appointment type enum
enum AppointmentType {
  @JsonValue('professional_booking')
  professionalBooking,
  @JsonValue('play_session')
  playSession,
  @JsonValue('tournament')
  tournament,
}

/// Appointment status enum
enum AppointmentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}

/// Lobby status enum
enum LobbyStatus {
  @JsonValue('active')
  active,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('full')
  full,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('completed')
  completed,
}

/// Extensions for better UI display
extension AppointmentTypeExtension on AppointmentType {
  String get displayName {
    switch (this) {
      case AppointmentType.professionalBooking:
        return 'Professional Session';
      case AppointmentType.playSession:
        return 'Play Session';
      case AppointmentType.tournament:
        return 'Tournament';
    }
  }
}

extension AppointmentStatusExtension on AppointmentStatus {
  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.completed:
        return 'Completed';
    }
  }
}

extension LobbyStatusExtension on LobbyStatus {
  String get displayName {
    switch (this) {
      case LobbyStatus.active:
        return 'Active';
      case LobbyStatus.scheduled:
        return 'Scheduled';
      case LobbyStatus.full:
        return 'Full';
      case LobbyStatus.cancelled:
        return 'Cancelled';
      case LobbyStatus.completed:
        return 'Completed';
    }
  }
}