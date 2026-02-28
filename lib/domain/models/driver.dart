class Driver {
  final String id;
  final String name;
  final bool isActive;

  const Driver({
    required this.id,
    required this.name,
    this.isActive = true,
  });
}
