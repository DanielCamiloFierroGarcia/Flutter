
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth__service.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(children: [
        const Text("We've sent you an email verification. Open it to verify"),
        const Text("If you haven't received and email verification yet, press the button below"),
        TextButton(onPressed: () {
          context.read<AuthBloc>().add(const AuthEventSendEmailVerification(),);
        }, child: const Text('Send email verification'),
        ),
        TextButton(onPressed: () async{
          context.read<AuthBloc>().add(const AuthEventLogOut(),);
        }, child: const Text('Restart'),)
      ],
      ),
    );
  }
}