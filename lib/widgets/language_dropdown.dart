import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    required this.selectedLanguage,
    required this.onChanged,
    super.key,
  });

  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  final List<String> availableLanguages = ['uk', 'en'];

  @override
  Widget build(BuildContext context) {
    String dropdownValue = availableLanguages.contains(widget.selectedLanguage)
        ? widget.selectedLanguage
        : 'uk';

    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        if (newValue != null) {
          widget.onChanged(newValue);
        }
      },
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem(
          value: 'uk',
          child: Text('Украинский'),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Text('Английский'),
        ),
      ],
    );
  }
}
