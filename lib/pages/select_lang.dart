import 'package:adhyayan/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguagePage extends StatefulWidget {
  final Function(String) onLanguageSelected;

  const SelectLanguagePage({super.key, required this.onLanguageSelected});

  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'hi', 'label': 'हिन्दी'},
    {'code': 'bn', 'label': 'বাংলা'},
    {'code': 'pa', 'label': 'ਪੰਜਾਬੀ'},
    {'code': 'gu', 'label': 'ગુજરાતી'}
  ];

  String _selectedLanguage = 'en';

  Future<void> _saveLanguagePreference(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  void _selectLanguage(String code) {
    setState(() {
      _selectedLanguage = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[700]!,
              Colors.green[500]!,
              Colors.green[300]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.select_lang,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    return GestureDetector(
                      onTap: () => _selectLanguage(language['code']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        decoration: BoxDecoration(
                          color: _selectedLanguage == language['code']
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: _selectedLanguage == language['code']
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            language['label']!,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: _selectedLanguage == language['code']
                                  ? Colors.green[700]
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () async {
                    await _saveLanguagePreference(_selectedLanguage);
                    widget.onLanguageSelected(_selectedLanguage);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continuee,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
