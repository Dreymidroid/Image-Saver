import 'package:first/bloc/app_event.dart';
import 'package:first/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailCtrl;
  late final TextEditingController passwordCtrl;

  @override
  void initState() {
    super.initState();
    emailCtrl = TextEditingController(text: 'dadefemiwa@gmail.com'.ifDebugging);
    passwordCtrl =
        TextEditingController(text: 'testEmail@gmail.com'.ifDebugging);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(hintText: 'Enter Email'),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordCtrl,
              decoration: const InputDecoration(
                hintText: 'Enter Password',
              ),
              obscureText: true,
            ),
            TextButton(
                onPressed: () {
                  final email = emailCtrl.text;
                  final password = passwordCtrl.text;

                  context.read<AppBloc>().add(AppEventLogIn(
                        email: email,
                        password: password,
                      ));
                },
                child: const Text('Log In')),
            TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        const AppEventGoToRegistration(),
                      );
                },
                child: const Text('Not Registered Yet?'))
          ],
        ),
      ),
    );
  }
}
