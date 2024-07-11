import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/entry.dart';

/// typedef used to specify member type exactly as EntryID
typedef EntryId = String;

/// abstract entries service class, containing CRUD functions to implement
abstract class EntriesService {
  Future<void> deleteEntryById(
    EntryId id, {
    required String userId,
  });

  /// delete all entries by specified user
  Future<void> deleteAllEntries({
    required String userId,
  });

  Future<EntryId> createEntry({
    required String userId,
    required String text,
    required DateTime creationDate,
  });

  Future<void> modifyEntry({
    required String userId,
    required EntryId entryId,
    String? entryText,
    bool? isDone,
  });

  /// load all entries by specified user
  Future<Iterable<Entry>> loadEntries({
    required String userId,
  });

  /// set flag entry has image assigned
  Future<void> setEntryHasImageOrNot({
    required EntryId entryId,
    required String userId,
    required bool hasImage,
  });

  Future<Uint8List?> getEntryImage({
    required EntryId entryId,
    required String userId,
  });
}

/// Firestore implementation of EntriesService API
class FirestoreEntriesService implements EntriesService {
  /// creates journal entry in firebase
  @override
  Future<EntryId> createEntry({
    required String userId,
    required String text,
    required DateTime creationDate,
  }) async {
    final creationDate = DateTime.now();

    /// creates journal entry in firebase
    final firebaseEntry =
        await FirebaseFirestore.instance.collection(userId).add(
      {
        _DocumentKeys.text: text,
        _DocumentKeys.creationDate: creationDate.toIso8601String(),
        _DocumentKeys.isDone: false,
        _DocumentKeys.hasImage: false,
      },
    );

    return firebaseEntry.id;
  }

  /// delete all entries by user ID
  @override
  Future<void> deleteAllEntries({
    required String userId,
  }) async {
    final store = FirebaseFirestore.instance;
    final operation = store.batch();

    /// receiving all documents by userId
    final collection = await store.collection(userId).get();

    /// iterating by docs & deleting
    for (final document in collection.docs) {
      operation.delete(document.reference);

      /// delete image assigned with that entry
      try {
        await FirebaseStorage.instance.ref(userId).child(document.id).delete();
      } catch (e) {
        // not handling exceptions for now, add sometime later
      }
    }

    /// commit to delete all user`s entries
    await operation.commit();
  }

  /// deleteEntry By Id AND userId
  @override
  Future<void> deleteEntryById(
    EntryId id, {
    required String userId,
  }) async {
    // get docs by userId
    final collection =
        await FirebaseFirestore.instance.collection(userId).get();

    // find doc by id
    final firebaseEntry = collection.docs.firstWhere(
      (element) => element.id == id,
    );
    // delete from firebase
    await firebaseEntry.reference.delete();

    // delete image assigned with that entry
    try {
      await FirebaseStorage.instance
          .ref(userId)
          .child(firebaseEntry.id)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// load entries by userId
  @override
  Future<Iterable<Entry>> loadEntries({
    required String userId,
  }) async {
    final collection =
        await FirebaseFirestore.instance.collection(userId).get();

    final entries = collection.docs.map(
      (doc) => Entry(
        id: doc.id,
        creationDate: DateTime.parse(doc[_DocumentKeys.creationDate] as String),
        isDone: doc[_DocumentKeys.isDone] as bool,
        text: doc[_DocumentKeys.text] as String,
        hasImage: doc[_DocumentKeys.hasImage] as bool,
      ),
    );
    return entries;
  }

  /// update the remote Firebase entry
  Future<void> _modify({
    required EntryId entryId,
    required String userId,
    required Map<String, Object?> keyValues,
  }) async {
    // get docs by userid
    final collection =
        await FirebaseFirestore.instance.collection(userId).get();

    // find entry by id
    final firebaseEntry = collection.docs
        .where((element) => element.id == entryId)
        .first
        .reference;

    // update entry using key-value map keyValues
    await firebaseEntry.update(
      keyValues,
    );
  }

  /// entry update wrapper
  @override
  Future<void> modifyEntry({
    required String userId,
    required EntryId entryId,
    String? entryText,
    bool? isDone,
  }) async {
    if (isDone != null) {
      _modify(
        userId: userId,
        entryId: entryId,
        keyValues: {
          _DocumentKeys.isDone: isDone,
        },
      );
    }

    if (entryText != null) {
      _modify(
        userId: userId,
        entryId: entryId,
        keyValues: {
          _DocumentKeys.text: entryText,
        },
      );
    }
  }

  /// image object getter from FirebaseStorage
  @override
  Future<Uint8List?> getEntryImage({
    required EntryId entryId,
    required String userId,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref(userId).child(entryId);
      final data = await ref.getData();
      return data;
    } catch (_) {
      return null;
    }
  }

  /// set/unset hasImage flag by entry in Firebase
  @override
  Future<void> setEntryHasImageOrNot({
    required EntryId entryId,
    required String userId,
    required bool hasImage,
  }) =>
      _modify(
        entryId: entryId,
        userId: userId,
        keyValues: {
          _DocumentKeys.hasImage: hasImage,
        },
      );
}

/// definition of document fields
abstract class _DocumentKeys {
  static const text = 'text';
  static const creationDate = 'creation_date';
  static const isDone = 'is_done';
  static const hasImage = 'has_image';
}
