import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

/// dialog widget used for Journal entry deletion;
/// based on generic dialog widget
Future<bool> showDeleteEntryDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete entry',
    content:
        'Are you sure you want to delete this journal entry? You cannot undo this action!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
