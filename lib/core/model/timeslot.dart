import 'package:json_annotation/json_annotation.dart';

import 'enum.dart';

part 'timeslot.g.dart';

@JsonSerializable()
class Timeslot {
  final DayOfWeek dayOfWeek;
  final DayChunk dayChunk;

  Timeslot(this.dayOfWeek, this.dayChunk);

  // Factory constructor for deserialization
  factory Timeslot.fromJson(Map<String, dynamic> json) =>
      _$TimeslotFromJson(json);

  // Method for serialization
  Map<String, dynamic> toJson() => _$TimeslotToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Timeslot &&
        other.dayOfWeek == dayOfWeek &&
        other.dayChunk == dayChunk;
  }

  @override
  int get hashCode => dayOfWeek.hashCode ^ dayChunk.hashCode;
}