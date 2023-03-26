// ignore_for_file: use_build_context_synchronously

import 'package:first/bloc/app_event.dart';
import 'package:first/dialogs/log_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import '../dialogs/delete_account_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              context.read<AppBloc>().add(
                    const AppEventLogOut(),
                  );
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAcc = await showDeleteAccountDialog(context);
            if (shouldDeleteAcc) {
              context.read<AppBloc>().add(
                    const AppEventDeleteAccount(),
                  );
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
              value: MenuAction.logout, child: Text('Log Out')),
          const PopupMenuItem<MenuAction>(
              value: MenuAction.deleteAccount, child: Text('Delete Acc'))
        ];
      },
    );
  }
}
