import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phytosvit/database/doc_type_dao.dart';
import 'package:phytosvit/database/sq_light/database_helper.dart';
import 'package:phytosvit/database/subdivision_dao.dart';
import 'package:phytosvit/database/unit_dao.dart';
import 'package:phytosvit/generated/l10n.dart';
import 'package:phytosvit/screens/login_screen.dart';
import 'package:phytosvit/database/user_dao.dart';
import 'package:phytosvit/screens/main_screen.dart';
import 'package:phytosvit/screens/registration_screen.dart';
import 'package:phytosvit/services/doc_type_sync_service.dart';
import 'package:phytosvit/services/subdivision_sync_service.dart';
import 'package:phytosvit/services/unit_sync_service.dart';
import 'package:phytosvit/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:phytosvit/services/user_sync_service.dart';
import 'package:phytosvit/services/settings_service.dart';
import 'package:phytosvit/providers/theme_provider.dart';
import 'package:phytosvit/providers/locale_provider.dart';
import 'package:phytosvit/services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация SettingsService
  await dotenv.load();
  final settingsService = SettingsService();
  final userDao = UserDao();
  final unitDao = UnitDao();
  final docTypeDao = DocTypeDao();
  final subdivisionDao = SubdivisionDao();
  final userSyncService = UserSyncService(settingsService, userDao);
  final unitSyncService = UnitSyncService(unitDao);
  final docTypeSyncService = DocTypeSyncService(docTypeDao);
  final subdivisionSyncService = SubdivisionSyncService(subdivisionDao);
  final permissionService = PermissionService();

  // Запрос разрешений
  await permissionService.requestLocationPermission();

  // Загрузка настроек
  await settingsService.loadSettings();

  // Инициализация базы данных
  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  // Попытка синхронизации данных пользователей, единиц и подразделений
  await _syncData(userSyncService, unitSyncService, subdivisionSyncService,
      docTypeSyncService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(settingsService.isDarkTheme),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(settingsService.language),
        ),
        Provider(create: (_) => userDao),
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) =>
              LoginViewModel(userDao: userDao, syncService: userSyncService),
        ),
        Provider(
          create: (_) => UserSyncService(settingsService, userDao),
        ),
      ],
      child: PhytosvitApp(settingsService: settingsService),
    ),
  );
}

Future<void> _syncData(
  UserSyncService userSyncService,
  UnitSyncService unitSyncService,
  SubdivisionSyncService subdivisionSyncService,
  DocTypeSyncService docTypeSyncService,
) async {
  try {
    // Синхронизация пользователей, единиц и подразделений
    await userSyncService.syncUsers();
    await unitSyncService.syncUnits();
    await subdivisionSyncService.syncSubdivisions();
    await docTypeSyncService.syncDocTypes();
  } catch (e) {
    debugPrint('Ошибка при синхронизации данных: $e');
  }
}

class PhytosvitApp extends StatelessWidget {
  final SettingsService settingsService;

  const PhytosvitApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Phytosvit',
      theme: themeProvider.themeData,
      locale: localeProvider.locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/main': (context) => const MainScreen(),
      },
      home: FutureBuilder(
        future: _initializeSyncData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка синхронизации данных'));
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  Future<void> _initializeSyncData(BuildContext context) async {
    final syncService = Provider.of<UserSyncService>(context, listen: false);

    // Ожидаем, пока база данных будет готова
    final dbHelper = DatabaseHelper();
    await dbHelper.database;

    // Запускаем синхронизацию после создания базы данных
    await syncService.syncUsers();
  }
}
