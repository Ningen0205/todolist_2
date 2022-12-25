import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/exception.dart';

class WeekPasswordException extends BaseException {
  WeekPasswordException(super.message);
}

class EmailAlreadyInUseException extends BaseException {
  EmailAlreadyInUseException(super.message);
}

class UnknownRegisterFailedException extends BaseException {
  UnknownRegisterFailedException(super.message);
}

class UnknownLoginFailedException extends BaseException {
  UnknownLoginFailedException(super.message);
}

const WEEK_PASSWORD = 'week-password';
const EMAIL_ALREADY_IN_USE = 'email-already-in-use';

const USER_NOT_FOUND = 'user-not-found';
const WRONG_PASSWORD = 'wrong-password';

class AccountLogic {
  Future<User?> login(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case USER_NOT_FOUND:
        case WRONG_PASSWORD:
          return null;
        default:
          throw UnknownLoginFailedException('unknown error');
      }
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case WEEK_PASSWORD:
          throw WeekPasswordException('week_password');
        case EMAIL_ALREADY_IN_USE:
          throw EmailAlreadyInUseException('email_already_in_use');
        default:
          throw UnknownRegisterFailedException('unknown_error');
      }
    }
  }
}
