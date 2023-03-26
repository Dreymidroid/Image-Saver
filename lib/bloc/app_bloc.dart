import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first/auth/auth_error.dart';
import 'package:first/bloc/app_event.dart';
import 'package:first/bloc/app_states.dart';
import 'package:first/utils/upload_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventUploadImage>(
      (event, emit) async {
        //  ||  Handle Upload
        final user = state.user;
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        //  ||  Start Loading
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );
        //  ||  Uploading File
        final file = File(event.filePathToUpload);
        await uploadImage(file: file, userId: user.uid);

        //  ||  Updating References
        final images = await _getImages(user.uid);
        //  ||  Emit New Images
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      },
    );

    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = state.user;

        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }

        //  ||  Start Loading
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        try {
          //  ||  Delete User Folder Contents
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();

          for (final item in folderContents.items) {
            await item.delete().catchError((_) {});
          }

          //  ||  Delete User Folder
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          //  ||  Delete The User
          await user.delete();
          //  ||  Sign User Out on Firebase and on UI
          await FirebaseAuth.instance.signOut();
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        }
      },
    );

    on<AppEventLogOut>((event, emit) async {
      //  ||  Log The User Out: UI || Start Loading
      emit(const AppStateLoggedOut(
        isLoading: true,
      ));

      //  ||  Log The User Out: Firebase
      // await FirebaseAuth.instance.signOut();
      //  ||  Log The User Out: UI
      emit(const AppStateLoggedOut(
        isLoading: false,
      ));
    });

    on<AppEventInitialize>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        } else {
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              user: user,
              images: images,
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AppEventRegister>(
      (event, emit) async {
        emit(
          const AppStateIsInRegistrationView(isLoading: true),
        );
        final email = event.email;
        final password = event.password;
        try {
          //  ||  Create User
          final credentials =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          final userId = credentials.user!.uid;
          //  ||  Log in User || Creating user auto signs in
          emit(
            AppStateLoggedIn(
              user: credentials.user!,
              images: const [],
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          print(e);
          emit(AppStateIsInRegistrationView(
              isLoading: false, authError: AuthError.from(e)));
        } on FirebaseException {
          print("e");

          emit(
            const AppStateIsInRegistrationView(
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AppEventGoToLogin>(
      (event, emit) {
        emit(const AppStateLoggedOut(isLoading: false));
      },
    );

    on<AppEventLogIn>(
      (event, emit) async {
        //  ||  Start Loading
        emit(const AppStateLoggedOut(isLoading: true));
        try {
          //  ||  Logging User: Firebase
          final email = event.email;
          final password = event.password;
          final userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredential.user!;
          final images = await _getImages(user.uid);
          //  ||  Logging User: UI
          emit(
            AppStateLoggedIn(
              user: user,
              images: images,
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    on<AppEventGoToRegistration>(
      (event, emit) {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
