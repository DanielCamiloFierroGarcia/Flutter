//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth__service.dart';
import 'package:myproject/views/login_view.dart';
import 'package:myproject/views/notes_view.dart';
import 'package:myproject/views/register_view.dart';
import 'package:myproject/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  )
    ,);
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if(user != null){
              if(user.isEmailVerified){
                return const NotesView();
              }
              else{
                return const VerifyEmailView();
              }
            }
            else{
              return const LoginView();
            }
          default :
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
