import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style/colors.dart';
import '../widgets/document_widget.dart';
import '../widgets/documents_widget.dart';
import 'barcode_scanner_screen.dart';

/// Главный экран с нижней навигацией и разными AppBar для каждой вкладки
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Ключ для DocumentsWidget, чтобы иметь возможность обновлять список документов
  final GlobalKey<DocumentsWidgetState> docsKey =
      GlobalKey<DocumentsWidgetState>();

  int _currentPage = 0;
  bool _hideBottomMenu = false;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DocumentsWidget(key: docsKey),
      const Center(child: Text('Історія')),
      const Center(child: Text('')),
      const Center(child: Text('Файли')),
      const Center(child: Text('Мій кабінет')),
    ];
  }

  /// Выбираем AppBar в зависимости от выбранной вкладки
  PreferredSizeWidget? _buildAppBar() {
    switch (_currentPage) {
      case 0:
        return AppBar(
          title: const Text(
            'Документи',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg/ico_add_doc.svg',
                // Если ассеты отсутствуют, можно указать семантическую метку
                semanticsLabel: 'Add Document',
              ),
              onPressed: () async {
                // Открываем экран создания/редактирования документа
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DocumentWidget(
                      barcodes: [],
                    ),
                  ),
                );
                if (result == 'saved') {
                  docsKey.currentState?.refreshDocuments();
                }
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg/ico_settings_doc.svg',
                semanticsLabel: 'Settings',
              ),
              onPressed: () {
                // Логика открытия настроек
              },
            ),
          ],
        );
      case 1:
        return AppBar(
          title: const Text(
            'Історія',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey,
        );
      case 2:
        return AppBar(
          title: const Text(
            'QR Scanner',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey,
        );
      case 3:
        return AppBar(
          title: const Text(
            'Файли',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey,
        );
      case 4:
        return AppBar(
          title: const Text(
            'Мій кабінет',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey,
        );
      default:
        return null;
    }
  }

  /// Метод для формирования SVG-иконки с перекраской в зависимости от выбранной вкладки
  Widget _svgIcon(String assetName, int index) {
    final isSelected = (index == _currentPage);
    return SvgPicture.asset(
      'assets/svg/$assetName',
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.greenTeeColor : Colors.black,
        BlendMode.srcIn,
      ),
      width: 24,
      height: 24,
    );
  }

  /// Построение нижней навигационной панели с плавающей кнопкой
  Widget _buildBottomNavBar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          elevation: 0,
          shadowColor: Colors.grey,
          child: BottomNavigationBar(
            currentIndex: _currentPage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.greenTeeColor,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              setState(() => _currentPage = index);
            },
            items: [
              BottomNavigationBarItem(
                icon: _svgIcon('ico_home.svg', 0),
                label: 'Головна',
              ),
              BottomNavigationBarItem(
                icon: _svgIcon('ico_history.svg', 1),
                label: 'Історія',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _svgIcon('ico_files.svg', 3),
                label: 'Файл',
              ),
              BottomNavigationBarItem(
                icon: _svgIcon('ico_profile.svg', 4),
                label: 'Мій кабінет',
              ),
            ],
          ),
        ),
        // Позиционируем FloatingActionButton поверх BottomNavigationBar
        Positioned(
          top: -28,
          left: MediaQuery.of(context).size.width / 2 - 42.5,
          child: SizedBox(
            width: 85,
            height: 85,
            child: FloatingActionButton(
              elevation: 4,
              onPressed: _onFabPressed,
              backgroundColor: AppColors.greenTeeColor,
              shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 6.0,
                ),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Обработка нажатия на FloatingActionButton
  Future<void> _onFabPressed() async {
    setState(() {
      _hideBottomMenu = true;
    });

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        _hideBottomMenu = false;
      });
      // После получения результата переходим к DocumentWidget для работы с результатом
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => DocumentWidget(
            barcodes: [
              {result: 1},
            ],
          ),
        ),
      )
          .then((res) {
        if (res == 'saved') {
          docsKey.currentState?.refreshDocuments();
        }
      });
    } else {
      setState(() {
        _hideBottomMenu = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _hideBottomMenu ? null : _buildAppBar(),
      body: IndexedStack(
        index: _currentPage,
        children: _pages,
      ),
      bottomNavigationBar: _hideBottomMenu ? null : _buildBottomNavBar(),
    );
  }
}

/// Точка входа приложения
void main() {
  runApp(const MyApp());
}

/// Корневой виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Menu with AppBar',
      theme: ThemeData(
        primaryColor: AppColors.greenTeeColor,
      ),
      home: const DocumentsWidget(),
    );
  }
}
