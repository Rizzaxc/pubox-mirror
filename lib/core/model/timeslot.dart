// TimeSlot model class
import 'enum.dart';

class Timeslot {
  final DayOfWeek dayOfWeek;
  final DayChunk dayChunk;

  Timeslot(this.dayOfWeek, this.dayChunk);

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