import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phytosvit/style/colors.dart';
import 'package:phytosvit/utils/custom_input_decoration.dart';
import 'package:phytosvit/services/settings_service.dart';
import 'package:phytosvit/widgets/language_dropdown_widget.dart';
import 'package:phytosvit/providers/theme_provider.dart';
import 'package:phytosvit/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  final TextEditingController _apiController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  String _selectedLanguage = 'uk';
  bool _isDarkTheme = false;
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.loadSettings();
    if (mounted) {
      setState(() {
        _apiController.text = _settingsService.apiAddress;
        _tokenController.text = _settingsService.apiToken;
        _selectedLanguage = _settingsService.language;
        _isDarkTheme = _settingsService.isDarkTheme;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _settingsService.saveApiAddress(_apiController.text);
      await _settingsService.saveApiToken(_tokenController.text);
      await _settingsService.saveLanguage(_selectedLanguage);
      await _settingsService.saveTheme(_isDarkTheme);

      if (mounted) {
        debugPrint(_selectedLanguage);
        Provider.of<ThemeProvider>(context, listen: false)
            .toggleTheme(_isDarkTheme);
        Provider.of<LocaleProvider>(context, listen: false)
            .changeLocale(_selectedLanguage);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Ошибка при сохранении настроек: $e');
    }
  }

  @override
  void dispose() {
    _apiController.dispose();
    _tokenController.dispose();
    super.dispose();
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
                        S.of(context).settings,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).setting_language,
                                  style: TextStyle(fontSize: 16.0)),
                              LanguageDropdown(
                                selectedLanguage: _selectedLanguage,
                                onChanged: (value) {
                                  setState(() {
                                    debugPrint(value);
                                    _selectedLanguage = value!;
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
                                activeColor: AppColors.greenTeeColor,
                                inactiveThumbColor: AppColors.greenTeeColor,
                                inactiveTrackColor:
                                    AppColors.greenTeeColor.withOpacity(0.3),
                                trackOutlineColor:
                                    WidgetStateProperty.resolveWith(
                                  (final Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return null;
                                    }
                                    return AppColors.greenTeeColor;
                                  },
                                ),
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
                          const SizedBox(height: 40.0),
                          // Настройки API
                          _buildInputField(
                            controller: _apiController,
                            label: S.of(context).api_address,
                          ),
                          const SizedBox(height: 20.0),
                          _buildInputField(
                            controller: _tokenController,
                            label: S.of(context).api_token,
                          ),
                          const SizedBox(height: 40.0),
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
                                S.of(context).save,
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

  // Метод для построения поля ввода с кастомным стилем
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration:
            customInputDecoration(label), // Используем customInputDecoration
      ),
    );
  }
}
