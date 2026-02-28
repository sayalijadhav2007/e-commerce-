class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'don',
      email: json['email'] as String? ?? 'don@example.com',
      phone: json['phone'] as String? ?? '+91 90000 00000',
      address: json['address'] as String? ?? 'Mumbai, India',
      city: json['city'] as String? ?? 'Mumbai',
      country: json['country'] as String? ?? 'India',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 19.0760,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 72.8777,
    );
  }

  static UserProfile defaultProfile({String? email}) {
    return UserProfile(
      name: 'don',
      email: email ?? 'don@example.com',
      phone: '+91 90000 00000',
      address: 'Mumbai, India',
      city: 'Mumbai',
      country: 'India',
      latitude: 19.0760,
      longitude: 72.8777,
    );
  }
}
