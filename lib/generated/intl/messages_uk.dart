// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk locale. All the
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
  String get localeName => 'uk';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "language_english": MessageLookupByLibrary.simpleMessage("Англійська"),
        "language_ukraine": MessageLookupByLibrary.simpleMessage("Українська"),
        "login_forgot_password":
            MessageLookupByLibrary.simpleMessage("Забули пароль ?"),
        "login_header_1":
            MessageLookupByLibrary.simpleMessage("Увійдіть у свій акаунт"),
        "login_header_2": MessageLookupByLibrary.simpleMessage(
            "Введіть адресу електронної пошти та пароль для входу"),
        "login_remember_me":
            MessageLookupByLibrary.simpleMessage("Запам\'ятати мене"),
        "setting_dark_theme":
            MessageLookupByLibrary.simpleMessage("Темна тема"),
        "setting_language": MessageLookupByLibrary.simpleMessage("Мова"),
        "title": MessageLookupByLibrary.simpleMessage("Phytosvit APP"),
        "user_email": MessageLookupByLibrary.simpleMessage("Електронна адреса"),
        "user_password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "user_sign_in": MessageLookupByLibrary.simpleMessage("Увійти")
      };
}
