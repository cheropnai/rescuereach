//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rescuereach/services/reports/report.dart';
//import 'package:personalnotesapp/services/crud/notes_service.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class notesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const notesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);

          return ListTile(
            onTap: () {
              onTap(note);
            },
            subtitle: Text(
              note.text,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            title: Text(
              note.timeStamp,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
