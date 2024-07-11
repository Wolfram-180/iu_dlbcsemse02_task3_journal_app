import 'package:flutter/material.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/show_textfield_dialog.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/main_popup_menu_button.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/entries_list_view.dart';
import 'package:provider/provider.dart';

class EntriesView extends StatelessWidget {
  const EntriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal entries'),
        actions: [
          IconButton(
            onPressed: () async {
              final EntryText = await showTextFieldDialog(
                context: context,
                title: 'What is entry about?',
                hintText: 'Enter your journal entry here',
                optionsBuilder: () => {
                  TextFieldDialogButtonType.cancel: 'Cancel',
                  TextFieldDialogButtonType.confirm: 'Save',
                },
              );
              if (EntryText == null) {
                return;
              }
              context.read<AppState>().createEntry(EntryText);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: const EntriesListView(),
    );
  }
}
