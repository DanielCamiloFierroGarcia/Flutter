import 'package:flutter/cupertino.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'We have sent new password reset link, check email',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
