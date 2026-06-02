import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import 'data/auth_repository.dart';
import 'domain/app_user.dart';

class AuthSession {
  const AuthSession({required this.user});

  final AppUser? user;
  bool get hasAccess => user?.hasAccess == true;
}

class AuthController extends AsyncNotifier<AuthSession> {
  late final AuthRepository _repository;

  @override
  Future<AuthSession> build() async {
    _repository = ref.watch(authRepositoryProvider);
    final user = await _repository.currentUser();
    return AuthSession(user: user);
  }

  Future<void> continueAsGuest(String name, bool acceptedTerms) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _repository.signInGuest(
        name: name.trim().isEmpty ? AppConstants.defaultGuestName : name.trim(),
        acceptedTerms: acceptedTerms,
      );
      return AuthSession(user: user);
    });
  }

  Future<void> continueWithGoogle(bool acceptedTerms) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await _repository.signInGoogle(acceptedTerms: acceptedTerms);
      return AuthSession(user: user);
    });
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(AuthSession(user: null));
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthSession>(AuthController.new);
