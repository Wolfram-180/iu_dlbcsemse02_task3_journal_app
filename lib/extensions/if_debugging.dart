import 'package:flutter/foundation.dart' show kDebugMode;

/// extension to show assigned string in case of Debug mode
/// for ease of debugging
extension IfDebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
}
