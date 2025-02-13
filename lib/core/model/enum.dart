// follow database ID
enum Sport {
  others,
  soccer,
  basketball,
  badminton,
  tennis,
  // pickleball
}

enum DayChunk {
  early, // 4am-9am
  midday, // 9am-2pm
  noon, // 2pm-6pm
  night // 6pm-12pm
}

enum DayOfWeek {
  everyday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  even, // mon wed fri
  odd, // tue thu sat
  weekend // sat sun
}

enum StakeUnit {
  game,
  set,
  goal
}