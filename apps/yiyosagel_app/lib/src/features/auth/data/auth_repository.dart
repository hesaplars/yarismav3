import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/app_user.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _functions = functions,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;
  final GoogleSignIn _googleSignIn;

  Future<AppUser?> currentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    final result = await _functions.httpsCallable('bootstrapProfile').call();
    return AppUser.fromJson(Map<String, dynamic>.from(result.data as Map));
  }

  Future<AppUser> signInGuest({required String name, required bool acceptedTerms}) async {
    final credential = await _auth.signInAnonymously();
    final result = await _functions.httpsCallable('completeGuestAccess').call({
      'name': name,
      'avatar': AppConstants.defaultGuestAvatar,
      'acceptedTerms': acceptedTerms,
    });
    return AppUser.fromJson({
      'uid': credential.user?.uid,
      ...Map<String, dynamic>.from(result.data as Map),
    });
  }

  Future<AppUser> signInGoogle({required bool acceptedTerms}) async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw StateError('Google girisi iptal edildi.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    final result = await _functions.httpsCallable('completeGoogleAccess').call({
      'acceptedTerms': acceptedTerms,
    });
    return AppUser.fromJson(Map<String, dynamic>.from(result.data as Map));
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    functions: FirebaseFunctions.instanceFor(region: AppConstants.functionsRegion),
    googleSignIn: GoogleSignIn(),
  );
});
