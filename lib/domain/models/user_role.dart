enum UserRole {
  driver,
  manager,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.driver:
        return 'Delivery Man';
      case UserRole.manager:
        return 'Manager';
    }
  }
}
