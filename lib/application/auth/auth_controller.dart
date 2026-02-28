import 'dart:convert';

import 'package:dual_role_delivery_app/domain/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? email;

  const AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    required this.email,
  });

  const AuthState.loading() : this(isLoading: true, isAuthenticated: false, email: null);

  AuthState copyWith({bool? isLoading, bool? isAuthenticated, String? email}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(const AuthState.loading()) {
    _load();
  }

  final Ref ref;
  SharedPreferences? _prefs;

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final isAuthenticated = _prefs?.getBool('wagba_logged_in') ?? false;
    final email = _prefs?.getString('wagba_email');
    state = AuthState(isLoading: false, isAuthenticated: isAuthenticated, email: email);
    if (isAuthenticated) {
      await ref.read(userProfileProvider.notifier).loadProfile(emailOverride: email);
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    final stored = prefs.getString('wagba_password_$email');
    if (stored == null || stored != password) {
      return false;
    }
    await prefs.setBool('wagba_logged_in', true);
    await prefs.setString('wagba_email', email);
    state = state.copyWith(isAuthenticated: true, email: email);
    await ref.read(userProfileProvider.notifier).loadProfile(emailOverride: email);
    return true;
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    await prefs.setString('wagba_password_$email', password);
    await prefs.setBool('wagba_logged_in', true);
    await prefs.setString('wagba_email', email);
    state = state.copyWith(isAuthenticated: true, email: email);

    final profile = UserProfile.defaultProfile(email: email).copyWith(
      name: name.isEmpty ? 'don' : name,
      phone: phone.isEmpty ? '+91 90000 00000' : phone,
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
  }

  Future<bool> resetPassword({required String email, required String newPassword}) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    final stored = prefs.getString('wagba_password_$email');
    if (stored == null) return false;
    await prefs.setString('wagba_password_$email', newPassword);
    return true;
  }

  Future<void> signOut() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    await prefs.setBool('wagba_logged_in', false);
    state = state.copyWith(isAuthenticated: false, email: null);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

class UserProfileController extends StateNotifier<UserProfile> {
  UserProfileController(this.ref) : super(UserProfile.defaultProfile());

  final Ref ref;

  Future<void> loadProfile({String? emailOverride}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('wagba_user_profile');
    if (raw != null) {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      state = UserProfile.fromJson(json).copyWith(
        email: emailOverride ?? json['email'] as String? ?? state.email,
      );
    } else {
      state = UserProfile.defaultProfile(email: emailOverride ?? state.email);
      await saveProfile(state);
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    state = profile;
    await prefs.setString('wagba_user_profile', jsonEncode(profile.toJson()));
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileController, UserProfile>((ref) {
  return UserProfileController(ref);
});
