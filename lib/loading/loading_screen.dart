import 'dart:async';
import 'package:iu_dlbcsemse02_task3_journal_app/loading/loading_screen_controller.dart';
import 'package:flutter/material.dart';

/// "Singleton" pattern used, factory method returns previously created _shared instance
class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    /// return if no text to update
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      /// otherwise show overlay using _showOverlay wrapper on Overlay (with OverlayEntry) widget
      _controller = _showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  /// _showOverlay wrapper based on Overlay (with OverlayEntry) widget
  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    /// received text - sent to stream streamText
    final streamText = StreamController<String>();
    streamText.add(text);

    /// stack of OverlayEntry entries that can be managed independently.
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),

                      /// StreamBuilder used here to get text sent to streamText, catched as snapshot data
                      /// and displayed by Text widget
                      StreamBuilder<String>(
                        stream: streamText.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    /// prepared overlay object - inserted in overlay stack
    state.insert(overlay);

    //TODO: check
    return LoadingScreenController(
      close: () {
        streamText.close();
        overlay.remove();
        return true;
      },
      update: (String text) {
        streamText.add(text);
        return true;
      },
    );
  }
}
