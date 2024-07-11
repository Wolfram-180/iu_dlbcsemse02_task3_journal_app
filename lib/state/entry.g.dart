// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Entry on _Entry, Store {
  late final _$hasImageAtom = Atom(name: '_Entry.hasImage', context: context);

  @override
  bool get hasImage {
    _$hasImageAtom.reportRead();
    return super.hasImage;
  }

  @override
  set hasImage(bool value) {
    _$hasImageAtom.reportWrite(value, super.hasImage, () {
      super.hasImage = value;
    });
  }

  late final _$imageDataAtom = Atom(name: '_Entry.imageData', context: context);

  @override
  Uint8List? get imageData {
    _$imageDataAtom.reportRead();
    return super.imageData;
  }

  @override
  set imageData(Uint8List? value) {
    _$imageDataAtom.reportWrite(value, super.imageData, () {
      super.imageData = value;
    });
  }

  late final _$isLoadingAtom = Atom(name: '_Entry.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$textAtom = Atom(name: '_Entry.text', context: context);

  @override
  String get text {
    _$textAtom.reportRead();
    return super.text;
  }

  @override
  set text(String value) {
    _$textAtom.reportWrite(value, super.text, () {
      super.text = value;
    });
  }

  late final _$isDoneAtom = Atom(name: '_Entry.isDone', context: context);

  @override
  bool get isDone {
    _$isDoneAtom.reportRead();
    return super.isDone;
  }

  @override
  set isDone(bool value) {
    _$isDoneAtom.reportWrite(value, super.isDone, () {
      super.isDone = value;
    });
  }

  @override
  String toString() {
    return '''
hasImage: ${hasImage},
imageData: ${imageData},
isLoading: ${isLoading},
text: ${text},
isDone: ${isDone}
    ''';
  }
}
