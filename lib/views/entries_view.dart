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
        title: const Text('ToDo-s journal entries'),
        actions: const [
          MainPopupMenuButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Add entry',
        onPressed: () async {
          final entryText = await showTextFieldDialog(
            context: context,
            title: 'What is entry about?',
            hintText: 'Enter your journal entry here',
            optionsBuilder: () => {
              TextFieldDialogButtonType.cancel: 'Cancel',
              TextFieldDialogButtonType.confirm: 'Save',
            },
          );
          if (entryText == null) {
            return;
          }
          context.read<AppState>().createEntry(entryText);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: const EntriesListView(),
    );
  }
}
