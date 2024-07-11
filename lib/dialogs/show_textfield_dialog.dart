import 'package:flutter/material.dart';

/// enumeration containing text dialog buttons types
enum TextFieldDialogButtonType {
  cancel,
  confirm,
}

//TODO: add doc
typedef DialogOptionBuilder = Map<TextFieldDialogButtonType, String> Function();

final controller = TextEditingController();

/// dialog form with text input
/// based on Material - AlertDialog class
Future<String?> showTextFieldDialog({
  required BuildContext context,
  required String title,
  required String? hintText,
  required DialogOptionBuilder optionsBuilder,
  isTextEdit = false,
  oldText = '',
}) {
  controller.clear();
  final options = optionsBuilder();

  if (isTextEdit) controller.text = oldText;

  return showDialog<String?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: isTextEdit
            ? TextField(
                autofocus: true,
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              )
            : TextField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
        actions: options.entries
            .map(
              (option) => TextButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    option.key == TextFieldDialogButtonType.confirm
                        ? controller.text
                        : null,
                  );
                },
                child: Text(option.value),
              ),
            )
            .toList(),
      );
    },
  );
}
