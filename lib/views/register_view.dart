import 'package:first/bloc/app_event.dart';
import 'package:first/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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

                  context.read<AppBloc>().add(AppEventRegister(
                        email: email,
                        password: password,
                      ),);
                },
                child: const Text('Register')),
            TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        const AppEventGoToLogin(),
                      );
                },
                child: const Text('Already Registered?'))
          ],
        ),
      ),
    );
  }
}
