import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

/// dialog widget used in Account deletion;
/// based on generic dialog widget
Future<bool> showDeleteAccountDialog(BuildContext context) async {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete account',
    content:
        'Are you sure you want to delete your account? This action is irreversible.',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
