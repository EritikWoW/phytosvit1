// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Phytosvit APP`
  String get title {
    return Intl.message(
      'Phytosvit APP',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `E-mail address`
  String get user_email {
    return Intl.message(
      'E-mail address',
      name: 'user_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get user_password {
    return Intl.message(
      'Password',
      name: 'user_password',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get user_sign_in {
    return Intl.message(
      'Log in',
      name: 'user_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to your account`
  String get login_header_1 {
    return Intl.message(
      'Sign in to your account',
      name: 'login_header_1',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and password to login`
  String get login_header_2 {
    return Intl.message(
      'Enter your email and password to login',
      name: 'login_header_2',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get login_remember_me {
    return Intl.message(
      'Remember me',
      name: 'login_remember_me',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password ?`
  String get login_forgot_password {
    return Intl.message(
      'Forgot Password ?',
      name: 'login_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get setting_language {
    return Intl.message(
      'Language',
      name: 'setting_language',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get setting_dark_theme {
    return Intl.message(
      'Dark theme',
      name: 'setting_dark_theme',
      desc: '',
      args: [],
    );
  }

  /// `Ukrainian`
  String get language_ukraine {
    return Intl.message(
      'Ukrainian',
      name: 'language_ukraine',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get language_english {
    return Intl.message(
      'English',
      name: 'language_english',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get user_name {
    return Intl.message(
      'Name',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get user_confirm_password {
    return Intl.message(
      'Repeat password',
      name: 'user_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get registration_header_1 {
    return Intl.message(
      'Sign up',
      name: 'registration_header_1',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get registration_header_2 {
    return Intl.message(
      'Already have an account?',
      name: 'registration_header_2',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get register_now {
    return Intl.message(
      'Sign up',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Registering`
  String get button_user_register {
    return Intl.message(
      'Registering',
      name: 'button_user_register',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get login_back_to_login {
    return Intl.message(
      'Log in',
      name: 'login_back_to_login',
      desc: '',
      args: [],
    );
  }

  /// `You entered the wrong password.`
  String get error_invalid_password {
    return Intl.message(
      'You entered the wrong password.',
      name: 'error_invalid_password',
      desc: '',
      args: [],
    );
  }

  /// `User with this email address not found`
  String get error_user_not_found {
    return Intl.message(
      'User with this email address not found',
      name: 'error_user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error_generic {
    return Intl.message(
      'Error',
      name: 'error_generic',
      desc: '',
      args: [],
    );
  }

  /// `Document`
  String get document_title {
    return Intl.message(
      'Document',
      name: 'document_title',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `API Address`
  String get api_address {
    return Intl.message(
      'API Address',
      name: 'api_address',
      desc: '',
      args: [],
    );
  }

  /// `API Token`
  String get api_token {
    return Intl.message(
      'API Token',
      name: 'api_token',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `QR Content`
  String get qr_content {
    return Intl.message(
      'QR Content',
      name: 'qr_content',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'uk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
