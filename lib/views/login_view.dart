import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/extensions/if_debugging.dart';
import 'package:iu_dlbcsemse02_task3_journal_app/state/app_state.dart';

/// log in screen
class LoginView extends HookWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'sergei.ulvis@gmail.com'.ifDebugging,
    );

    final passwordController = useTextEditingController(
      text: 'dabracababra'.ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log in',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '*',
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Log in'),
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppState>().login(
                      email: email,
                      password: password,
                    );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Not registered yet? Register here!'),
              onPressed: () {
                context.read<AppState>().goTo(
                      AppScreen.register,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
