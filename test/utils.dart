import 'package:flutter/foundation.dart';

/// one second duration for testing purposes
const oneSecond = Duration(
  seconds: 1,
);

/// type extension to have delay for testing purpose
extension WithDelay<T> on T {
  Future<T> toFuture([Duration? delay]) =>
      delay != null ? Future.delayed(delay, () => this) : Future.value(this);
}

/// String type extension converting toUint8List for testing purpose
/// to emulate image from string
extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(
        codeUnits,
      );
}
