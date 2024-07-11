import 'package:flutter_test/flutter_test.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';

import 'mocks/mock_auth_service.dart';
import 'mocks/mock_image_upload_service.dart';
import 'mocks/mock_entry_service.dart';

void main() {
  late AppState appState;
  setUp(
    () {
      appState = AppState(
        authService: MockAuthService(),
        entriesService: MockEntriesService(),
        imageUploadService: MockImageUploadService(),
      );
    },
  );

  test(
    'initial state',
    () {
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
      appState.authError.expectNull();
      appState.isLoading.expectFalse();
      appState.entries.isEmpty.expectTrue();
    },
  );

  test(
    'going to screens',
    () {
      appState.goTo(AppScreen.register);
      expect(
        appState.currentScreen,
        AppScreen.register,
      );
      appState.goTo(AppScreen.journalEntries);
      expect(
        appState.currentScreen,
        AppScreen.journalEntries,
      );
      appState.goTo(AppScreen.login);
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
    },
  );

  test(
    'initializing the app state',
    () async {
      await appState.initialize();
      expect(
        appState.currentScreen,
        AppScreen.journalEntries,
      );
      // Entrys should be loaded
      expect(
        appState.entries.length,
        mockEntrys.length,
      );

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

  test(
    'modifying entries',
    () async {
      await appState.initialize();
      await appState.modifyEntryIsDone(
        entryId: mockEntry1Id,
        isDone: false,
      );
      await appState.modifyEntryIsDone(
        entryId: mockEntry2Id,
        isDone: true,
      );
      final entry1 = appState.entries.firstWhere(
        (entry) => entry.id == mockEntry1Id,
      );
      final entry2 = appState.entries.firstWhere(
        (entry) => entry.id == mockEntry2Id,
      );
      entry1.isDone.expectFalse();
      entry2.isDone.expectTrue();
    },
  );

  test(
    'creating entries',
    () async {
      await appState.initialize();
      const text = 'text';
      final didCreate = await appState.createEntry(
        text,
      );
      didCreate.expectTrue();
      expect(
        appState.entries.length,
        mockEntrys.length + 1,
      );

      // checking new entry
      final testEntry = appState.entries.firstWhere(
        (element) => element.id == mockEntryId,
      );
      expect(
        testEntry.text,
        text,
      );
      testEntry.isDone.expectFalse();
    },
  );

  test(
    'deleting entries',
    () async {
      await appState.initialize();
      final count = appState.entries.length;
      final entry = appState.entries.first;
      final deleted = await appState.deleteEntry(entry);
      deleted.expectTrue();
      expect(
        appState.entries.length,
        count - 1,
      );
    },
  );

  test(
    'deleting account',
    () async {
      await appState.initialize();
      final couldDeleteAccount = await appState.deleteAccount();
      couldDeleteAccount.expectTrue();
      appState.entries.isEmpty.expectTrue();
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
    },
  );

  test(
    'logging out',
    () async {
      await appState.initialize();
      await appState.logOut();
      appState.entries.isEmpty.expectTrue();
      expect(
        appState.currentScreen,
        AppScreen.login,
      );
    },
  );

  test(
    'uploading image for entry',
    () async {
      await appState.initialize();
      final entry = appState.entries.firstWhere(
        (element) => element.id == mockEntry1Id,
      );
      entry.hasImage.expectFalse();
      entry.imageData.expectNull();

      // fake image upload for entry
      final couldUploadImage = await appState.uploadEntryImage(
        filePath: 'dummy_path',
        forEntryId: entry.id,
      );

      couldUploadImage.expectTrue();
      entry.hasImage.expectTrue();
      entry.imageData.expectNull();

      final imageData = await appState.getEntryImage(
        entryId: entry.id,
      );

      imageData.expectNotNull();
      imageData!
          .isEqualTo(
            mockEntry1ImageData,
          )
          .expectTrue();
    },
  );
}

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
