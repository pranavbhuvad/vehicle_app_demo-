import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthController(this._repository) : super(AuthState(status: AuthStatus.unauthenticated));

  Future<void> loginCustomer(String email, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    try {
      final data = await _repository.login(email, password);
      final token = data['token'] as String;
      final userMap = data['user'] as Map<String, dynamic>;

      await _storage.write(key: StorageKeys.authToken, value: token);
      
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: UserModel.fromJson(userMap),
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> signupCustomer({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating);
    try {
      final data = await _repository.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      final token = data['token'] as String;
      final userMap = data['user'] as Map<String, dynamic>;

      await _storage.write(key: StorageKeys.authToken, value: token);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: UserModel.fromJson(userMap),
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logoutCustomer() async {
    await _storage.delete(key: StorageKeys.authToken);
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}