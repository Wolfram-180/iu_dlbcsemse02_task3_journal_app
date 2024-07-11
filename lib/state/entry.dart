import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'entry.g.dart';

/// Model for journal entry
class Entry = _Entry with _$Entry;

/// Entry with Store mixin to support code generation
abstract class _Entry with Store {
  final String id;
  final DateTime creationDate;

  /// Entry has image?
  @observable
  bool hasImage;

  /// Entry imageData
  @observable
  Uint8List? imageData;

  /// is Entry in loading state
  @observable
  bool isLoading;

  /// Entry text
  @observable
  String text;

  /// is Entry done
  @observable
  bool isDone;

  /// constructor
  _Entry({
    required this.id,
    required this.text,
    required this.isDone,
    required this.creationDate,
    required this.hasImage,
  }) : isLoading = false;

  /// overriding equality operator ==
  /// adding other class fields in comparison
  /// to have proper comparison including all fields
  @override
  bool operator ==(covariant _Entry other) =>
      id == other.id &&
      text == other.text &&
      isDone == other.isDone &&
      creationDate == other.creationDate;

  /// overriding Object.hash method
  /// adding other class members in hashing
  /// to have proper hashing including all fields
  @override
  int get hashCode => Object.hash(
        id,
        text,
        isDone,
        creationDate,
      );
}
