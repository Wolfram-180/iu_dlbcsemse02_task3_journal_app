import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/dialogs/show_auth_error.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/firebase_options.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/loading/loading_screen.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/services/auth_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/services/image_upload_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/services/entries_service.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/login_view.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/register_view.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/views/entries_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Provider(
      create: (_) => AppState(
        authService: FirebaseAuthService(),
        entriesService: FirestoreEntriesService(),
        imageUploadService: FirebaseImageUploadService(),
      )..initialize(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ReactionBuilder(
        builder: (context) {
          return autorun(
            (_) {
              // handle loading screen
              final isLoading = context.read<AppState>().isLoading;
              if (isLoading) {
                LoadingScreen.instance().show(
                  context: context,
                  text: 'Loading...',
                );
              } else {
                LoadingScreen.instance().hide();
              }

              final authError = context.read<AppState>().authError;

              if (authError != null) {
                showAuthError(
                  authError: authError,
                  context: context,
                );
              }
            },
          );
        },
        child: Observer(
          name: 'CurrentScreen',
          builder: (context) {
            switch (context.read<AppState>().currentScreen) {
              case AppScreen.login:
                return const LoginView();
              case AppScreen.register:
                return const RegisterView();
              case AppScreen.journalEntries:
                return const EntriesView();
            }
          },
        ),
      ),
    );
  }
}
