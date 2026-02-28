class WagbaCategory {
  final String id;
  final String name;
  final String imagePath;

  const WagbaCategory({
    required this.id,
    required this.name,
    required this.imagePath,
  });
}

class WagbaMeal {
  final String id;
  final String name;
  final String imagePath;
  final double rating;
  final double price;
  final String description;
  final String categoryId;

  const WagbaMeal({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.price,
    required this.description,
    required this.categoryId,
  });
}
