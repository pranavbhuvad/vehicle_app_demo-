import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Explicit profile screen view states
enum ProfileStatus { loading, loaded, unauthenticated }

class ProfileState {
  final ProfileStatus status;
  final String name;
  final String email;
  final String phone;

  ProfileState({
    required this.status,
    this.name = '',
    this.email = '',
    this.phone = '',
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? email,
    String? phone,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController() : super(ProfileState(status: ProfileStatus.unauthenticated)) {
    loadUserProfile(); // Automatically load standard fallback dummy data on initialization
  }

  /// Injects dummy data matching your test dashboard credentials
  void loadUserProfile() {
    state = ProfileState(
      status: ProfileStatus.loaded,
      name: "Pranav Bhuvad",
      email: "abc@gmail.com",
      phone: "8888888888",
    );
  }

  /// Triggers a clean fallback UI state changes locally
  void clearProfileSession() {
    state = ProfileState(status: ProfileStatus.unauthenticated);
  }
}

/// Global provider reference for the profile feature boundary
final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController();
});