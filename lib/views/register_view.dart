
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/utilities/show_dialog.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';

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
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              }on FirebaseAuthException catch (e){
                if(e.code == 'weak-password'){
                  await showErrorDialog(context, 'Weak password');
                }
                else if(e.code == 'email-already-in-use'){
                  await showErrorDialog(context, 'That email address is already in use');
                }
                else if(e.code == 'invalid-email'){
                  await showErrorDialog(context, 'That email is not valid');
                }
                else{
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e){
                await showErrorDialog(context, e.toString());
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
