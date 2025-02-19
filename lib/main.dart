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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Загрузка переменных окружения (.env)
  await dotenv.load();

  // 2. Инициализация сервисов
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

  // 3. Запрос разрешений (например, на геолокацию)
  await permissionService.requestLocationPermission();

  // 4. Загрузка пользовательских настроек (тема, язык)
  await settingsService.loadSettings();

  // 5. Инициализация базы данных
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // Убедимся, что база создана

  // 6. Запуск приложения
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
          create: (_) => userSyncService,
        ),
        Provider(create: (_) => unitSyncService),
        Provider(create: (_) => docTypeSyncService),
        Provider(create: (_) => subdivisionSyncService),
      ],
      child: PhytosvitApp(
        settingsService: settingsService,
        userSyncService: userSyncService,
        unitSyncService: unitSyncService,
        docTypeSyncService: docTypeSyncService,
        subdivisionSyncService: subdivisionSyncService,
      ),
    ),
  );
}

class PhytosvitApp extends StatelessWidget {
  final SettingsService settingsService;
  final UserSyncService userSyncService;
  final UnitSyncService unitSyncService;
  final DocTypeSyncService docTypeSyncService;
  final SubdivisionSyncService subdivisionSyncService;

  const PhytosvitApp({
    super.key,
    required this.settingsService,
    required this.userSyncService,
    required this.unitSyncService,
    required this.docTypeSyncService,
    required this.subdivisionSyncService,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Phytosvit',
      theme: themeProvider.themeData,
      locale: localeProvider.locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
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
      // Используем FutureBuilder, чтобы показывать "загрузку" во время синхронизации
      home: FutureBuilder(
        future: _initializeSyncData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Ошибка синхронизации данных: ${snapshot.error}'),
              ),
            );
          } else {
            // Если всё ок — идём на экран логина (или на MainScreen, как вам нужно)
            return const LoginScreen();
          }
        },
      ),
    );
  }

  // Здесь выполняем полную синхронизацию (users, units, doc types, subdivisions)
  Future<void> _initializeSyncData(BuildContext context) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.database;

    // Полная синхронизация
    await userSyncService.syncUsers();
    await unitSyncService.syncUnits();
    await subdivisionSyncService.syncSubdivisions();
    await docTypeSyncService.syncDocTypes();
  }
}
