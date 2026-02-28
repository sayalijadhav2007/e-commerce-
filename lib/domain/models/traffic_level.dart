enum TrafficLevel {
  low,
  medium,
  high;

  double get factor {
    switch (this) {
      case TrafficLevel.low:
        return 1.0;
      case TrafficLevel.medium:
        return 1.5;
      case TrafficLevel.high:
        return 2.0;
    }
  }
}

TrafficLevel trafficLevelFromName(String name) {
  switch (name) {
    case 'low':
      return TrafficLevel.low;
    case 'medium':
      return TrafficLevel.medium;
    case 'high':
      return TrafficLevel.high;
  }
  return TrafficLevel.low;
}
