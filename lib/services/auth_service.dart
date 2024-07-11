import 'package:firebase_auth/firebase_auth.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/auth/auth_error.dart';

/// abstract class AuthService used as parent for
/// exact Firebase auth actions
abstract class AuthService {
  String? get userId;
  Future<bool> deleteAccountAndSignOut();
  Future<void> signOut();
  Future<bool> register({
    required String email,
    required String password,
  });
  Future<bool> login({
    required String email,
    required String password,
  });
}

class FirebaseAuthService implements AuthService {
  @override

  /// delete account and sign out
  Future<bool> deleteAccountAndSignOut() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      // user delete
      await user.delete();
      // log the user out
      await auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthError.from(e);
    } catch (e) {
      rethrow;
    }
  }

  @override

  /// user log in, based on signInWithEmailAndPassword (FirebaseAuth)
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthError.from(e);
    } catch (e) {
      rethrow;
    }
    return FirebaseAuth.instance.currentUser != null;
  }

  @override

  /// user log in, based on createUserWithEmailAndPassword (FirebaseAuth)
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthError.from(e);
    } catch (e) {
      rethrow;
    }
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      /// ignoring errors for sign out as for time shortage
      ///TODO: add exceptions handling
    }
  }

  @override
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
}
