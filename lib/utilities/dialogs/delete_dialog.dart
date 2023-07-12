import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'delete',
    content: 'are you sure you want to delete this item?',
    optionsBuilder: () => {
      'cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false,
  );
}
