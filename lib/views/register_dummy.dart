import 'package:rescuereach/services/auth/bloc/auth_bloc.dart';
import 'package:rescuereach/services/auth/bloc/auth_event.dart';
import 'package:rescuereach/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dummy extends StatefulWidget {
  const Dummy({super.key});

  @override
  State<Dummy> createState() => _DummyState();
}

enum MenuAction { logout }


class _DummyState extends State<Dummy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            })
          ],
        ),
        body: const Text('You are a dummyyy'),
    );
  }
}