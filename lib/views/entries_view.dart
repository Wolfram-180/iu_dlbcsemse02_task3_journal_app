import 'package:flutter/material.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/show_textfield_dialog.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/main_popup_menu_button.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/entries_list_view.dart';
import 'package:provider/provider.dart';

/// Main screen base scaffold
/// containing AppBar, Floating Action Bar (FAB)
/// and entries list view
class EntriesView extends StatefulWidget {
  const EntriesView({super.key});

  @override
  _EntriesViewState createState() => _EntriesViewState();
}

class _EntriesViewState extends State<EntriesView> {
  Future<void> _addEntry() async {
    // capturing context locally to avoid issues with async gaps
    final localContext = context;
    final entryText = await showTextFieldDialog(
      context: localContext,
      title: 'What is entry about?',
      hintText: 'Enter your journal entry here',
      optionsBuilder: () => {
        TextFieldDialogButtonType.cancel: 'Cancel',
        TextFieldDialogButtonType.confirm: 'Save',
      },
    );
    if (!mounted) return;
    if (entryText == null) {
      return;
    }
    context.read<AppState>().createEntry(entryText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo-s Journal entries'),
        actions: const [
          MainPopupMenuButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Add entry',
        onPressed: _addEntry,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: const EntriesListView(),
    );
  }
}
