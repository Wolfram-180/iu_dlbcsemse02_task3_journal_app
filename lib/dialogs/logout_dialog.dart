import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

/// logout dialog based on generic dialog
Future<bool> showLogOutDialog(BuildContext context) async {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
