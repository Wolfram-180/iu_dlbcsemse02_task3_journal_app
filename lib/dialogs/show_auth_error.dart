import 'package:iu_dlbcsemse02_task3_journal_app/auth/auth_error.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

/// auth error dialog based on generic dialog
Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) async {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
