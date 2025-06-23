import 'package:json_annotation/json_annotation.dart';

import '../core/model/enum.dart';
import '../core/model/timeslot.dart';

part 'model.g.dart';

enum TeammateResultType { lobby, player }

enum ProfessionalRole { coach, referee }

@JsonSerializable()
class TeammateModel {
  final TeammateResultType teammateResultType;
  final String resultTitle;
  final List<String> location;
  final Timeslot playtime;
  final dynamic details;
  final double compatScore;
  final String searchableId;

  TeammateModel({
    required this.teammateResultType,
    required this.resultTitle,
    required this.location,
    required this.playtime,
    required this.details,
    required this.compatScore,
    required this.searchableId,
  });

  factory TeammateModel.fromJson(Map<String, dynamic> json) =>
      _$TeammateModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeammateModelToJson(this);

  @override
  String toString() {
    return 'TeammateModel(teammateResultType: $teammateResultType, resultTitle: $resultTitle, location: $location, playtime: $playtime, details: $details, compatScore: $compatScore, searchableId: $searchableId)';
  }

  TeammateModel copyWith({
    TeammateResultType? teammateResultType,
    String? resultTitle,
    List<String>? location,
    Timeslot? playtime,
    dynamic details,
    double? compatScore,
    String? searchableId,
  }) {
    return TeammateModel(
      teammateResultType: teammateResultType ?? this.teammateResultType,
      resultTitle: resultTitle ?? this.resultTitle,
      location: location ?? this.location,
      playtime: playtime ?? this.playtime,
      details: details ?? this.details,
      compatScore: compatScore ?? this.compatScore,
      searchableId: searchableId ?? this.searchableId,
    );
  }
}

@JsonSerializable()
class ChallengerModel {
  final String lobbyId;
  final Timeslot playtime;
  final String location;
  final double compatScore;
  final double fairplayScore; // rating past opponents give this lobby
  final dynamic records; // recent host lobby records
  final dynamic stake;
  final StakeUnit stakeUnit;

  ChallengerModel({
    required this.lobbyId,
    required this.playtime,
    required this.location,
    required this.compatScore,
    required this.fairplayScore,
    required this.records,
    required this.stake,
    required this.stakeUnit,
  });

  factory ChallengerModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengerModelToJson(this);

  @override
  String toString() {
    return 'ChallengeModel(lobbyId: $lobbyId, playtime: $playtime, location: $location, compatScore: $compatScore, fairplayScore: $fairplayScore, records: $records, stake: $stake, stakeUnit: $stakeUnit)';
  }

  ChallengerModel copyWith({
    String? lobbyId,
    dynamic playtime,
    String? location,
    double? compatScore,
    double? fairplayScore,
    dynamic records,
    dynamic stake,
    StakeUnit? stakeUnit,
  }) {
    return ChallengerModel(
      lobbyId: lobbyId ?? this.lobbyId,
      playtime: playtime ?? this.playtime,
      location: location ?? this.location,
      compatScore: compatScore ?? this.compatScore,
      fairplayScore: fairplayScore ?? this.fairplayScore,
      records: records ?? this.records,
      stake: stake ?? this.stake,
      stakeUnit: stakeUnit ?? this.stakeUnit,
    );
  }
}

@JsonSerializable()
class NeutralModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  NeutralModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory NeutralModel.fromJson(Map<String, dynamic> json) =>
      _$NeutralModelFromJson(json);

  Map<String, dynamic> toJson() => _$NeutralModelToJson(this);

  @override
  String toString() {
    return 'NeutralModel(id: $id, title: $title, description: $description, createdAt: $createdAt)';
  }

  NeutralModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return NeutralModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class LocationModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  LocationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  String toString() {
    return 'LocationModel(id: $id, title: $title, description: $description, createdAt: $createdAt)';
  }

  LocationModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return LocationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class ProfessionalModel {
  final int id;
  final String name;
  final String bio;
  final ProfessionalRole role;
  final String? avatarUrl;
  final double? rating;
  final int reviewCount;
  final int experienceYears;
  final bool isVerified;
  final bool isAvailable;
  final List<ProfessionalService> services;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfessionalModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.role,
    this.avatarUrl,
    this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.isVerified,
    required this.isAvailable,
    required this.services,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionalModelToJson(this);

  @override
  String toString() {
    return 'ProfessionalModel(id: $id, name: $name, role: $role, rating: $rating, reviewCount: $reviewCount)';
  }

  ProfessionalModel copyWith({
    int? id,
    String? name,
    String? bio,
    ProfessionalRole? role,
    String? avatarUrl,
    double? rating,
    int? reviewCount,
    int? experienceYears,
    bool? isVerified,
    bool? isAvailable,
    List<ProfessionalService>? services,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfessionalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experienceYears: experienceYears ?? this.experienceYears,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class ProfessionalService {
  final int id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final bool isActive;

  ProfessionalService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.isActive,
  });

  factory ProfessionalService.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionalServiceToJson(this);

  @override
  String toString() {
    return 'ProfessionalService(id: $id, name: $name, price: $price, duration: ${durationMinutes}min)';
  }

  ProfessionalService copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? durationMinutes,
    bool? isActive,
  }) {
    return ProfessionalService(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
    );
  }
}
