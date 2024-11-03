// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "language_english": MessageLookupByLibrary.simpleMessage("English"),
        "language_ukraine": MessageLookupByLibrary.simpleMessage("Ukrainian"),
        "login_forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Password ?"),
        "login_header_1":
            MessageLookupByLibrary.simpleMessage("Sign in to your account"),
        "login_header_2": MessageLookupByLibrary.simpleMessage(
            "Enter your email and password to login"),
        "login_remember_me":
            MessageLookupByLibrary.simpleMessage("Remember me"),
        "setting_dark_theme":
            MessageLookupByLibrary.simpleMessage("Dark theme"),
        "setting_language": MessageLookupByLibrary.simpleMessage("Language"),
        "title": MessageLookupByLibrary.simpleMessage("Phytosvit APP"),
        "user_email": MessageLookupByLibrary.simpleMessage("E-mail address"),
        "user_password": MessageLookupByLibrary.simpleMessage("Password"),
        "user_sign_in": MessageLookupByLibrary.simpleMessage("Log in")
      };
}
