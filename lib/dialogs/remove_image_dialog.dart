import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

/// dialog widget used for image (assigned with journal entry) removal
/// based on generic dialog widget
Future<bool> showRemoveMediaDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Remove media',
    content:
        'Are you sure you want to remove media assigned with this journal entry? You cannot undo this action!',
    optionsBuilder: () => {
      'Cancel': false,
      'Remove': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
