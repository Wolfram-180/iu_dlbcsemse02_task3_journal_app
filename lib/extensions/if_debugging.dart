import 'package:flutter/foundation.dart' show kDebugMode;

/// extension to wrap kDebugMode in more human-way
extension IfDebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
}
