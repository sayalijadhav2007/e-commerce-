/// Represents a customer's review score.
///
/// This is a simplified model. In a real app, this would be linked
/// to a user profile and contain more details.
class CustomerReview {
  /// A score from 1.0 to 5.0, where 5.0 is the best.
  final double rating;

  const CustomerReview({required this.rating})
      : assert(rating >= 1.0 && rating <= 5.0);

  Map<String, dynamic> toJson() {
    return {'rating': rating};
  }

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(rating: (json['rating'] as num).toDouble());
  }

  /// Provides a weight for the priority calculation.
  /// Higher-rated customers get a slight priority boost.
  int get weight {
    if (rating >= 4.5) return 10; // Consistently good customer
    if (rating >= 3.5) return 5; // Average customer
    return 0; // Low-rated or new customer
  }
}
