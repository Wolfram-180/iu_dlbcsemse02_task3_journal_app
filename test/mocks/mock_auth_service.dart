import 'package:iu_dlbcsemse02_task3_journal_app/services/auth_service.dart';
import '../utils.dart';

/// mock auth service to emulate auth operations
class MockAuthService implements AuthService {
  @override
  Future<bool> deleteAccountAndSignOut() => true.toFuture(
        oneSecond,
      );

  @override
  Future<bool> login({
    required String email,
    required String password,
  }) =>
      true.toFuture(
        oneSecond,
      );

  @override
  Future<bool> register({
    required String email,
    required String password,
  }) =>
      true.toFuture(
        oneSecond,
      );

  @override
  Future<void> signOut() => Future.delayed(
        oneSecond,
      );

  @override
  String? get userId => 'sergei.ulvis';
}
