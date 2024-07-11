import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/auth/auth_error.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/services/auth_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/services/image_upload_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/services/entries_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/entry.dart';

part 'app_state.g.dart';

/// main app class to manage app state
/// containing actions used to change state
class AppState = _AppState with _$AppState;

/// Store extension by MobX
/// to maintain state and code generation
abstract class _AppState with Store {
  final AuthService authService;
  final EntriesService entriesService;
  final ImageUploadService imageUploadService;

  /// constructor
  _AppState({
    required this.authService,
    required this.entriesService,
    required this.imageUploadService,
  });

  /// in MobX, observable defines a trackable field that stores the state
  ///
  /// initial value of currentScreen is AppScreen.login
  /// as interaction starts from user`s login
  @observable
  AppScreen currentScreen = AppScreen.login;

  /// is app in loading state
  @observable
  bool isLoading = false;

  /// any auth error ?
  @observable
  AuthError? authError;

  /// list of journal`s entries
  @observable
  ObservableList<Entry> entries = ObservableList<Entry>();

  /// in MobX, computed marks a getter that will derive new facts from the state and cache its output
  ///
  /// list of sorted journal`s entries
  /// using sorted() extension
  @computed
  ObservableList<Entry> get sortedEntries => ObservableList.of(
        entries.sorted(),
      );

  /// in MobX, action marks a method as an action that will modify the state
  ///
  /// goTo action change currentScreen observable to provided AppScreen
  /// to support routing
  @action
  void goTo(AppScreen screen) {
    currentScreen = screen;
  }

  /// delete entry action
  @action
  Future<bool> delete(
    Entry entry,
  ) async {
    isLoading = true;

    final userId = authService.userId;
    if (userId == null) {
      isLoading = false;
      return false;
    }

    try {
      // remote delete
      await entriesService.deleteEntryById(
        entry.id,
        userId: userId,
      );
      // local delete
      entries.removeWhere(
        (element) => element.id == entry.id,
      );

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// delete user account action
  @action
  Future<bool> deleteAccount() async {
    isLoading = true;

    final userId = authService.userId;
    if (userId == null) {
      isLoading = false;
      return false;
    }

    try {
      // remote delete all user`s docs
      await entriesService.deleteAllEntries(
        userId: userId,
      );

      // local delete all docs
      entries.clear();

      // delete acc & sign out
      await authService.deleteAccountAndSignOut();

      // changing screen to Login
      currentScreen = AppScreen.login;
      return true;
    } on AuthError catch (e) {
      authError = e;
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  /// log out user action
  @action
  Future<void> logOut() async {
    isLoading = true;
    await authService.signOut();
    entries.clear();
    isLoading = false;
    currentScreen = AppScreen.login;
  }

  /// create Entry action
  @action
  Future<bool> createEntry(String text) async {
    isLoading = true;

    // check user
    final userId = authService.userId;
    if (userId == null) {
      isLoading = false;
      return false;
    }

    final creationDate = DateTime.now();

    // create firebase entry
    final cloudEntryId = await entriesService.createEntry(
      userId: userId,
      text: text,
      creationDate: creationDate,
    );

    // create local entry
    final entry = Entry(
      creationDate: creationDate,
      id: cloudEntryId,
      isDone: false,
      text: text,
      hasImage: false,
    );

    // add new entry in app`s entries list
    entries.add(entry);
    isLoading = false;
    return true;
  }

  /// modify entry action
  @action
  Future<bool> modifyEntries({
    required EntryId entryId,
    required bool isDone,
  }) async {
    final userId = authService.userId;
    if (userId == null) {
      return false;
    }

    await entriesService.modifyEntry(
      entryId: entryId,
      isDone: isDone,
      userId: userId,
    );

    // update the local entry
    entries
        .firstWhere(
          (element) => element.id == entryId,
        )
        .isDone = isDone;

    return true;
  }

  @action
  Future<void> initialize() async {
    isLoading = true;
    final userId = authService.userId;
    if (userId != null) {
      await _loadEntries();
      currentScreen = AppScreen.journalEntries;
    } else {
      currentScreen = AppScreen.login;
    }
    isLoading = false;
  }

  @action
  Future<bool> _loadEntries() async {
    final userId = authService.userId;
    if (userId == null) {
      return false;
    }

    final entries = await entriesService.loadEntries(
      userId: userId,
    );

    this.entries = ObservableList.of(entries);
    return true;
  }

  @action
  Future<bool> _registerOrLogin({
    required LoginOrRegisterFunction fn,
    required String email,
    required String password,
  }) async {
    authError = null;
    isLoading = true;

    try {
      final succeeded = await fn(
        email: email,
        password: password,
      );

      if (succeeded) {
        await _loadEntries();
      }

      return succeeded;
    } on AuthError catch (e) {
      authError = e;
      return false;
    } finally {
      isLoading = false;
      if (authService.userId != null) {
        currentScreen = AppScreen.journalEntries;
      }
    }
  }

  @action
  Future<bool> register({
    required String email,
    required String password,
  }) =>
      _registerOrLogin(
        fn: authService.register,
        email: email,
        password: password,
      );

  @action
  Future<bool> login({
    required String email,
    required String password,
  }) =>
      _registerOrLogin(
        fn: authService.login,
        email: email,
        password: password,
      );

  @action
  Future<bool> upload({
    required String filePath,
    required EntryId forEntryId,
  }) async {
    final userId = authService.userId;
    if (userId == null) {
      return false;
    }

    //set the entry as loading while uploading the image
    final entry = entries.firstWhere(
      (element) => element.id == forEntryId,
    );
    entry.isLoading = true;

    final imageId = await imageUploadService.uploadImage(
      userId: userId,
      imageId: forEntryId,
      filePath: filePath,
    );

    if (imageId == null) {
      // add some noification on error
      entry.isLoading = false;
      return false;
    }

    await entriesService.setEntryHasImage(
      entryId: forEntryId,
      userId: userId,
    );

    entry.isLoading = false;
    entry.hasImage = true;
    return true;
  }

  Future<Uint8List?> getEntryImage({
    required EntryId entryId,
  }) async {
    final userId = authService.userId;
    if (userId == null) {
      return null;
    }

    final entry = entries.firstWhere(
      (element) => element.id == entryId,
    );

    // checking if image was previously loaded in local entry
    // to not repeatedly get it from web
    final existingImageData = entry.imageData;
    if (existingImageData != null) {
      return existingImageData;
    }

    final image = await entriesService.getEntryImage(
      entryId: entryId,
      userId: userId,
    );
    entry.imageData = image;
    return image;
  }
}

typedef LoginOrRegisterFunction = Future<bool> Function({
  required String email,
  required String password,
});

extension ToInt on bool {
  int toInt() => this ? 1 : 0;
}

/// entries sorting method
/// 1st sorting priority - done or not
/// 2nd sorting priority - creation date
extension Sorted on List<Entry> {
  List<Entry> sorted() => [...this]..sort(
      (lhs, rhs) {
        final isDone = lhs.isDone.toInt().compareTo(
              rhs.isDone.toInt(),
            );
        if (isDone != 0) return isDone;
        return lhs.creationDate.compareTo(rhs.creationDate);
      },
    );
}

enum AppScreen { login, register, journalEntries }
