import 'package:first/bloc/app_event.dart';
import 'package:first/bloc/app_states.dart';
import 'package:first/dialogs/show_auth_error_dialog.dart';
import 'package:first/loading/loading_screen.dart';
import 'package:first/views/login_view.dart';
import 'package:first/views/photo_gallery_view.dart';
import 'package:first/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';


class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            print(appState);
            if (appState.isLoading == true) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = appState.authError;
            if (authError != null) {
              showAuthError(
                context: context,
                error: authError,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
