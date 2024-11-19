import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String schoolName;
  final String className;
  final String gender;
  final String? photoUrl;
  final Function(String) changeLanguage;

  const ProfilePage({
    super.key,
    required this.name,
    required this.schoolName,
    required this.className,
    required this.gender,
    this.photoUrl,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.student_profile,
          style:
              const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LanguageSelector(
              currentLanguage: Localizations.localeOf(context).languageCode,
              onLanguageChanged: changeLanguage,
            ),
            // const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.green[100],
                            backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl!)
                                : null,
                            child: photoUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.green[700],
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ProfileDetailField(
                        label: AppLocalizations.of(context)!.name, value: name),
                    const SizedBox(height: 20),
                    ProfileDetailField(
                        label: AppLocalizations.of(context)!.class_name,
                        value: className),
                    const SizedBox(height: 20),
                    ProfileDetailField(
                        label: AppLocalizations.of(context)!.school_name,
                        value: schoolName),
                    const SizedBox(height: 20),
                    ProfileDetailField(
                        label: AppLocalizations.of(context)!.gender,
                        value: gender),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.logout,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }
}

class LanguageSelector extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLanguageBox(context, 'en', 'English', 'ENG'),
          _buildLanguageBox(context, 'hi', 'हिन्दी', 'HIN'),
          _buildLanguageBox(context, 'bn', 'বাংলা', 'BEN'),
          _buildLanguageBox(context, 'pa', 'ਪੰਜਾਬੀ', 'PUN'),
          _buildLanguageBox(context, 'gu', 'ગુજરાતી', 'GUJ'),
        ],
      ),
    );
  }

  Widget _buildLanguageBox(
      BuildContext context, String code, String name, String shortName) {
    bool isSelected = currentLanguage == code;
    return GestureDetector(
      onTap: () => onLanguageChanged(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              shortName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      controller: TextEditingController(text: value),
    );
  }
}
