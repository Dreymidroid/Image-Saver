import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import '../auth/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  bool operator ==(covariant AppState other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  // Hashing only the params this class is implementing
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'AppStateLoggedIn, images length: ${images.length}';
}

@override
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required super.isLoading,
    super.authError,
  });

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading: $isLoading, AuthError: $authError';
}

@override
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required super.isLoading,
    super.authError,
  });
}

extension GetUser on AppState {
  User? get user {
    final thisClass = this;
    if (thisClass is AppStateLoggedIn) {
      return thisClass.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final thisClass = this;
    if (thisClass is AppStateLoggedIn) {
      return thisClass.images;
    } else {
      return null;
    }
  }
}
