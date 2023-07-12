import 'package:flutter/material.dart';
import 'package:rescuereach/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: 'sharing',
      content: 'you cannot share an empty note',
      optionsBuilder: ()=> {
        'Ok':null
      });
}
