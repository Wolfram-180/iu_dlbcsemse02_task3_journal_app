import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/delete_entry_dialog.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';
import 'package:provider/provider.dart';

final _imagePicker = ImagePicker();

class EntriesListView extends StatelessWidget {
  const EntriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Observer(
      builder: (context) {
        return ListView.builder(
          itemCount: appState.sortedEntries.length,
          itemBuilder: (context, index) {
            return EntryTile(
              entryIndex: index,
              imagePicker: _imagePicker,
            );
          },
        );
      },
    );
  }
}

class EntryTile extends StatelessWidget {
  final int entryIndex;
  final ImagePicker imagePicker;

  const EntryTile({
    super.key,
    required this.entryIndex,
    required this.imagePicker,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final entry = appState.sortedEntries[entryIndex];

    return Observer(
      builder: (context) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: entry.isDone,
          onChanged: (isDone) {
            context.read<AppState>().modifyEntries(
                  entryId: entry.id,
                  isDone: isDone ?? false,
                );
          },
          subtitle: EntryImageView(
            EntryIndex: entryIndex,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  entry.text,
                  style: TextStyle(
                    decoration: entry.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              entry.isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
              entry.hasImage
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () async {
                        final image = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          appState.upload(
                            filePath: image.path,
                            forEntryId: entry.id,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.upload,
                      ),
                    ),
              IconButton(
                onPressed: () async {
                  final showDeleteEntry = await showDeleteEntryDialog(context);
                  if (showDeleteEntry) {
                    context.read<AppState>().delete(entry);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EntryImageView extends StatelessWidget {
  final int EntryIndex;

  const EntryImageView({
    super.key,
    required this.EntryIndex,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final Entry = appState.sortedEntries[EntryIndex];
    if (Entry.hasImage) {
      return FutureBuilder<Uint8List?>(
        future: appState.getEntryImage(
          entryId: Entry.id,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  height: 100,
                );
              } else {
                return const Center(
                  child: Icon(Icons.error),
                );
              }
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
