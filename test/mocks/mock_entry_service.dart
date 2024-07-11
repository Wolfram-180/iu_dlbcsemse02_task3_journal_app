import 'dart:typed_data';

import 'package:iu_dlbcsemse02_task3_journal_app/services/entries_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/entry.dart';

import '../utils.dart';

final mockEntry1DateTime = DateTime(
  2024,
  7,
  11,
  1,
  1,
  1,
);
const mockEntry1Id = '1';
const mockEntry1Text = 'Text1';
const mockEntry1IsDone = true;
final mockEntry1ImageData = 'image1'.toUint8List();
final mockEntry1 = Entry(
  id: mockEntry1Id,
  text: mockEntry1Text,
  creationDate: mockEntry1DateTime,
  isDone: mockEntry1IsDone,
  hasImage: false,
);

final mockEntry2DateTime = DateTime(
  2024,
  7,
  11,
  2,
  2,
  2,
);
const mockEntry2Id = '2';
const mockEntry2Text = 'Text2';
const mockEntry2IsDone = false;
final mockEntry2ImageData = 'image2'.toUint8List();
final mockEntry2 = Entry(
  id: mockEntry2Id,
  text: mockEntry2Text,
  creationDate: mockEntry2DateTime,
  isDone: mockEntry2IsDone,
  hasImage: false,
);

final Iterable<Entry> mockEntrys = [
  mockEntry1,
  mockEntry2,
];

const mockEntryId = 'mockEntryId';

class MockEntriesService implements EntriesService {
  @override
  Future<EntryId> createEntry({
    required String userId,
    required String text,
    required DateTime creationDate,
  }) =>
      mockEntryId.toFuture(oneSecond);

  @override
  Future<void> deleteAllEntries({
    required String userId,
  }) =>
      Future.delayed(oneSecond);

  @override
  Future<void> deleteEntryById(
    EntryId id, {
    required String userId,
  }) =>
      Future.delayed(oneSecond);

  @override
  Future<Iterable<Entry>> loadEntries({
    required String userId,
  }) =>
      mockEntrys.toFuture(oneSecond);

  @override
  Future<void> modifyEntry({
    required EntryId entryId,
    required bool isDone,
    required String userId,
  }) =>
      Future.delayed(oneSecond);

  @override
  Future<Uint8List?> getEntryImage({
    required EntryId entryId,
    required String userId,
  }) async {
    switch (entryId) {
      case mockEntry1Id:
        return mockEntry1ImageData;
      case mockEntry2Id:
        return mockEntry2ImageData;
      default:
        return null;
    }
  }

  @override
  Future<void> setEntryHasImage({
    required EntryId entryId,
    required String userId,
  }) async {
    mockEntrys
        .firstWhere(
          (element) => element.id == entryId,
        )
        .hasImage = true;
  }
}
