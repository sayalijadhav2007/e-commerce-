import 'package:flutter/material.dart';

/// Represents the urgency of a food order.
enum FoodUrgency {
  high,
  medium,
  low,
}

FoodUrgency foodUrgencyFromName(String name) {
  switch (name) {
    case 'high':
      return FoodUrgency.high;
    case 'medium':
      return FoodUrgency.medium;
    case 'low':
      return FoodUrgency.low;
  }
  return FoodUrgency.medium;
}

/// Extension to provide a numerical weight for priority calculation.
extension FoodUrgencyExtension on FoodUrgency {
  int get weight {
    switch (this) {
      case FoodUrgency.high:
        return 30; // High-urgency items get a significant priority boost.
      case FoodUrgency.medium:
        return 15;
      case FoodUrgency.low:
        return 5;
    }
  }

  Color get color {
    switch (this) {
      case FoodUrgency.high:
        return Colors.red.shade300;
      case FoodUrgency.medium:
        return Colors.orange.shade300;
      case FoodUrgency.low:
        return Colors.blue.shade300;
    }
  }
}
