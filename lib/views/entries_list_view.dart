import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/delete_entry_dialog.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/remove_image_dialog.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/show_textfield_dialog.dart';
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
        return Column(
          children: [
            const Divider(),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: entry.isDone,
              onChanged: (isDone) {
                context.read<AppState>().modifyEntryIsDone(
                      entryId: entry.id,
                      isDone: isDone ?? false,
                    );
              },
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () async {
                      final editedText = await showTextFieldDialog(
                        context: context,
                        title: 'Edit entry?',
                        isTextEdit: true,
                        oldText: entry.text,
                        hintText: '',
                        optionsBuilder: () => {
                          TextFieldDialogButtonType.cancel: 'Cancel',
                          TextFieldDialogButtonType.confirm: 'Save',
                        },
                      );
                      if (editedText == null) {
                        return;
                      }
                      context.read<AppState>().modifyEntryText(
                            entryId: entry.id,
                            text: editedText,
                          );
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                  entry.hasImage
                      ? IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (_) => EntryImageView(
                                entryIndex: entryIndex,
                                isPopup: true,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.remove_red_eye,
                          ),
                        )
                      : SizedBox(),
                  entry.hasImage
                      ? IconButton(
                          tooltip: 'Remove media',
                          onPressed: () async {
                            final showRemoveMedia =
                                await showRemoveMediaDialog(context);
                            if (showRemoveMedia) {
                              appState.removeEntryMedia(
                                forEntryId: entry.id,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                          ),
                        )
                      : IconButton(
                          tooltip: 'Add image',
                          onPressed: () async {
                            final image = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              appState.uploadEntryImage(
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
                      final showDeleteEntry =
                          await showDeleteEntryDialog(context);
                      if (showDeleteEntry) {
                        appState.deleteEntry(entry);
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ],
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
                  EntryImageView(
                    entryIndex: entryIndex,
                  ),
                  entry.isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class EntryImageView extends StatelessWidget {
  final int entryIndex;
  final bool isPopup;

  const EntryImageView({
    super.key,
    required this.entryIndex,
    this.isPopup = false,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final entry = appState.sortedEntries[entryIndex];
    if (entry.hasImage) {
      return FutureBuilder<Uint8List?>(
        future: appState.getEntryImage(
          entryId: entry.id,
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
                if (isPopup) {
                  return Dialog(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(
                                snapshot.data!,
                              ),
                              fit: BoxFit.cover)),
                    ),
                  );
                } else {
                  return Image.memory(
                    snapshot.data!,
                    height: 100,
                  );
                }
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
