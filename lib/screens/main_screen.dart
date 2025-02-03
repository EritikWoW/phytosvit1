import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phytosvit/style/colors.dart';
import 'package:phytosvit/widgets/document_widget.dart';
import 'package:phytosvit/screens/barcode_scanner_screen.dart';
import 'package:phytosvit/widgets/documents_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;
  bool _hideBottomMenu = false; // Флаг для скрытия меню

  final _pages = [
    DocumentsWidget(),
    const Center(child: Text('Історія')),
    QRScannerScreen(),
    const Center(child: Text('Файли')),
    const Center(child: Text('Мій кабінет')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _hideBottomMenu
          ? null
          : AppBar(
              title: const Text(
                'Документи',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.grey.withOpacity(0.5),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: SvgPicture.asset('assets/svg/ico_add_doc.svg'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DocumentWidget(
                        barcodes: [],
                      ),
                    ));
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/svg/ico_settings_doc.svg'),
                  onPressed: () {
                    // Логика открытия меню
                  },
                ),
              ],
            ),
      body: Stack(
        children: [
          _pages[_currentPage],
          if (_hideBottomMenu) // Скрываем меню, если нужно
            Positioned.fill(
              child: Container(color: Colors.white),
            ),
        ],
      ),
      bottomNavigationBar: _hideBottomMenu
          ? null
          : Stack(
              clipBehavior: Clip.none,
              children: [
                Material(
                  elevation: 0,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  child: BottomNavigationBar(
                    currentIndex: _currentPage,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    selectedItemColor: AppColors.greenTeeColor,
                    unselectedItemColor: Colors.black,
                    onTap: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/svg/ico_home.svg'),
                        label: 'Головна',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/svg/ico_history.svg'),
                        label: 'Історія',
                      ),
                      BottomNavigationBarItem(
                        icon: SizedBox.shrink(),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/svg/ico_files.svg'),
                        label: 'Файл',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset('assets/svg/ico_profile.svg'),
                        label: 'Мій кабінет',
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -28,
                  left: MediaQuery.of(context).size.width / 2 - 42.5,
                  child: SizedBox(
                    width: 85,
                    height: 85,
                    child: FloatingActionButton(
                      elevation: 4,
                      onPressed: () async {
                        setState(() {
                          _hideBottomMenu = true; // Скрыть меню
                        });

                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QRScannerScreen(),
                          ),
                        );

                        if (result != null && result is String) {
                          // Открыть DocumentWidget с результатом сканирования
                          setState(() {
                            _hideBottomMenu = false; // Показать меню
                            _currentPage = 2;
                          });
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DocumentWidget(barcodes: [
                              {result: 1},
                            ]),
                          ));
                        } else {
                          setState(() {
                            _hideBottomMenu = false;
                          });
                        }
                      },
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
            ),
    );
  }
}
