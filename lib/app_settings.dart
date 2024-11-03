import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phytosvit/style/colors.dart';
import 'package:phytosvit/widgets/custom_input_decoration.dart';
import 'package:phytosvit/widgets/settings/settings_service.dart';
import 'package:phytosvit/widgets/settings/language_dropdown.dart';
import 'package:phytosvit/widgets/settings/theme_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  final TextEditingController _apiController = TextEditingController();
  String _selectedLanguage = 'uk';
  bool _isDarkTheme = false;
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    var settings = await _settingsService.loadSettings();
    setState(() {
      _apiController.text = settings['api_address'];
      _selectedLanguage = settings['language'];
      _isDarkTheme = settings['isDarkTheme'];
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_address', _apiController.text);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setBool('isDarkTheme', _isDarkTheme);

    if (mounted) {
      Provider.of<ThemeProvider>(context, listen: false)
          .toggleTheme(_isDarkTheme);
      Provider.of<LocaleProvider>(context, listen: false)
          .changeLocale(_selectedLanguage);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenTeeColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: null,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 1, child: Container(color: AppColors.greenTeeColor)),
              Expanded(
                  flex: 1,
                  child: Container(color: AppColors.lightBackgroundColor)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/svg/login_logo.svg'),
                      const SizedBox(height: 24),
                      Text(
                        'Настройки',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 180),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _apiController,
                            decoration: customInputDecoration('API адрес'),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).setting_language,
                                  style: TextStyle(fontSize: 16.0)),
                              LanguageDropdown(
                                selectedLanguage: _selectedLanguage,
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      _selectedLanguage = value;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).setting_dark_theme,
                                  style: TextStyle(fontSize: 16.0)),
                              Switch(
                                value: _isDarkTheme,
                                onChanged: (value) {
                                  setState(() {
                                    _isDarkTheme = value;
                                    Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .toggleTheme(_isDarkTheme);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _saveSettings,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColors.greenTeeColor,
                            ),
                            child: Center(
                              child: Text(
                                'Сохранить',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
