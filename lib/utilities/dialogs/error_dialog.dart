
import 'package:flutter/cupertino.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text){
  return showGenericDialog(context: context, title: 'An error ocurred', content: text, optionsBuilder: () => {
    'Ok': null,
  },
  );
}