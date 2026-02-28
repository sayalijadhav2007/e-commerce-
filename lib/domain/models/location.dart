/// Represents a geographical location with latitude and longitude.
class Location {
  final double latitude;
  final double longitude;

  const Location(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lon': longitude,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Location(lat: ${latitude.toStringAsFixed(4)}, lon: ${longitude.toStringAsFixed(4)})';
  }
}
