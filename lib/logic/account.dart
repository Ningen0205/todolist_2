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

const WEEK_PASSWORD = 'week-password';
const EMAIL_ALREADY_IN_USE = 'email-already-in-use';

class AccountLogic {
  void login(String email, String password) {
    log('id: $email');
    log('password: $password');
  }

  void register(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
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
