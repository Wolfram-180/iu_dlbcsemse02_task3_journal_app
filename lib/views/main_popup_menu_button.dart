import 'package:flutter/material.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/delete_account_dialog.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/logout_dialog.dart';
import 'package:provider/provider.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

/// pop-up menu
/// in top-right screen corner
class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (MenuAction action) async {
        switch (action) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(
              context,
            );
            if (shouldLogOut) {
              context.read<AppState>().logOut();
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(
              context,
            );
            if (shouldDeleteAccount) {
              context.read<AppState>().deleteAccount();
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
