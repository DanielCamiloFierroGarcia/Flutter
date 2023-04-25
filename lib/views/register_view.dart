
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth__service.dart';
import 'package:myproject/utilities/show_dialog.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/auth_exceptions.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {

              final email = _email.text;
              final password = _password.text;

              try{
                await AuthService.firebase().createUser(
                    email: email,
                    password: password
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException{
                await showErrorDialog(context, 'Weak password');
              } on EmailAlreadyInUseAuthException{
                await showErrorDialog(context, 'That email address is already in use');
              } on InvalidEmailAuthException{
                await showErrorDialog(context, 'That email is not valid');
              } on GenericAuthException{
                await showErrorDialog(context, 'Failed to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
                  (route) => false,
            );
          }, child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
