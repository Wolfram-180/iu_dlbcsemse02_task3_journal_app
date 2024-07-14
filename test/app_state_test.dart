import 'package:flutter_test/flutter_test.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';

import 'mocks/mock_auth_service.dart';
import 'mocks/mock_image_upload_service.dart';
import 'mocks/mock_entry_service.dart';

/// Tests module entry point
/// tests started in terminal by command: flutter test
void main() {
  late AppState appState;

  /// initializing mock services
  /// which to be used in further tests
  setUp(
    () {
      appState = AppState(
        authService: MockAuthService(),
        entriesService: MockEntriesService(),
        imageUploadService: MockImageUploadService(),
      );
    },
  );

  /// testing app on-launch, initial state
  test(
    'initial state',
    () {
      /// for state when currentScreen is login screen
      expect(
        appState.currentScreen,
        AppScreen.login,
      );

      /// expecting that
      ///
      /// no auth error
      appState.authError.expectNull();

      /// not loading
      appState.isLoading.expectFalse();

      /// entries list is empty
      appState.entries.isEmpty.expectTrue();
    },
  );

  /// testing routing
  test(
    'going to screens',
    () {
      /// navigated to register screen
      appState.goTo(AppScreen.register);

      /// expecting currentScreen = AppScreen.register
      expect(
        appState.currentScreen,
        AppScreen.register,
      );

      /// navigated to entries screen
      appState.goTo(AppScreen.journalEntries);

      /// expecting currentScreen = AppScreen.journalEntries
      expect(
        appState.currentScreen,
        AppScreen.journalEntries,
      );

      /// navigated to login screen
      appState.goTo(AppScreen.login);

      /// expecting currentScreen = AppScreen.login
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
    },
  );

  /// testing entries loaded
  test(
    'initializing the app state',
    () async {
      /// in initialize we have entries loaded
      await appState.initialize();

      /// and routing to entries screen
      expect(
        appState.currentScreen,
        AppScreen.journalEntries,
      );

      /// entries should be loaded
      expect(
        appState.entries.length,
        mockEntrys.length,
      );

      /// both mock entries to be loaded
      appState.entries
          .contains(
            mockEntry1,
          )
          .expectTrue();
      appState.entries
          .contains(
            mockEntry2,
          )
          .expectTrue();
    },
  );

  /// testing entries updates
  test(
    'modifying entries',
    () async {
      await appState.initialize();

      /// setting isDone=false for mockentry1
      await appState.modifyEntryIsDone(
        entryId: mockEntry1Id,
        isDone: false,
      );

      /// setting isDone=true for mockentry2
      await appState.modifyEntryIsDone(
        entryId: mockEntry2Id,
        isDone: true,
      );

      /// instantiating entries objects from entries lists
      final entry1 = appState.entries.firstWhere(
        (entry) => entry.id == mockEntry1Id,
      );
      final entry2 = appState.entries.firstWhere(
        (entry) => entry.id == mockEntry2Id,
      );

      /// checking entry1.isDone == false
      entry1.isDone.expectFalse();

      /// checking entry2.isDone == true
      entry2.isDone.expectTrue();
    },
  );

  /// testing entries creation
  test(
    'creating entries',
    () async {
      await appState.initialize();
      const text = 'text';

      /// creating new entry and returning operation result
      final didCreate = await appState.createEntry(
        text,
      );

      /// checking operation result == true (entry created)
      didCreate.expectTrue();

      /// checking entries list length incremented by 1
      expect(
        appState.entries.length,
        mockEntrys.length + 1,
      );

      /// checking new entry text equal to test text
      final testEntry = appState.entries.firstWhere(
        (element) => element.id == mockEntryId,
      );
      expect(
        testEntry.text,
        text,
      );

      /// checking new entry isDone == false
      testEntry.isDone.expectFalse();
    },
  );

  /// testing entries deletion
  test(
    'deleting entries',
    () async {
      await appState.initialize();

      /// getting current state
      final count = appState.entries.length;
      final entry = appState.entries.first;

      /// delete entry and receive operation result
      final deleted = await appState.deleteEntry(entry);

      /// checking result == true
      deleted.expectTrue();

      /// checking entries list length decreased by 1
      expect(
        appState.entries.length,
        count - 1,
      );
    },
  );

  /// testing account deletion
  test(
    'deleting account',
    () async {
      await appState.initialize();

      /// delete account in mock service and receive operation result
      final couldDeleteAccount = await appState.deleteAccount();

      /// checking result == true
      couldDeleteAccount.expectTrue();

      /// checking entries empty
      appState.entries.isEmpty.expectTrue();

      /// checking screen routed to login
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
    },
  );

  /// checking log out
  test(
    'logging out',
    () async {
      await appState.initialize();
      await appState.logOut();

      /// checking entries empty
      appState.entries.isEmpty.expectTrue();

      /// checking screen routed to login
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
    },
  );

  /// checking image upload in mock service
  test(
    'uploading image for entry',
    () async {
      await appState.initialize();

      /// taking mockentry1
      final entry = appState.entries.firstWhere(
        (element) => element.id == mockEntry1Id,
      );

      /// checking no image assigned
      entry.hasImage.expectFalse();
      entry.imageData.expectNull();

      /// fake image upload for entry
      final couldUploadImage = await appState.uploadEntryImage(
        filePath: 'dummy_path',
        forEntryId: entry.id,
      );

      /// checking upload results
      couldUploadImage.expectTrue();
      entry.hasImage.expectTrue();
      entry.imageData.expectNull();

      /// getting uploaded image
      final imageData = await appState.getEntryImage(
        entryId: entry.id,
      );

      /// checking data received
      imageData.expectNotNull();
      imageData!
          .isEqualTo(
            mockEntry1ImageData,
          )
          .expectTrue();
    },
  );
}

/// that Object type extension used as shortcut
/// for Null or NotNull checks
extension Expectations on Object? {
  void expectNull() => expect(
        this,
        isNull,
      );
  void expectNotNull() => expect(
        this,
        isNotNull,
      );
}

/// that bool type extension used as shortcut
/// for True or False checks
extension BoolExpectations on bool {
  void expectTrue() => expect(
        this,
        true,
      );
  void expectFalse() => expect(
        this,
        false,
      );
}

/// that List type extension used as shortcut
/// for Lists equality checks
extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }
    if (length != other.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
