import 'package:flutter/material.dart';
import './/generated/l10n.dart';

class LanguageDropdown extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      items: [
        DropdownMenuItem(
          value: 'uk',
          child: Text(S.of(context).language_ukraine),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Text(S.of(context).language_english),
        ),
      ],
      onChanged: (String? value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
