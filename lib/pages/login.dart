// ignore_for_file: use_build_context_synchronously

import 'package:adhyayan/models/userinfo.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adhyayan/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  UserInfo? _userInfo;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final response = await http.get(Uri.parse(
          'https://mtqlvltkr5.execute-api.us-east-1.amazonaws.com/authlambda?Username=$username'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['Error'] == '-1') {
          _showErrorDialog(AppLocalizations.of(context)!.user_notfound);
        } else if (data['Password'] == password) {
          // Successful login
          await _saveLoginState(username);
          await _fetchUserInfo();

          if (_userInfo != null) {
            await _saveUserInfoToPreferences(_userInfo!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  changeLanguage: _changeLanguage, // Pass changeLanguage
                ),
              ),
            );
          } else {
            _showErrorDialog(AppLocalizations.of(context)!.fail_fetch_info);
          }
        } else {
          _showErrorDialog(AppLocalizations.of(context)!.incorrect_password);
        }
      } else {
        _showErrorDialog(AppLocalizations.of(context)!.error);
      }
    } catch (e) {
      _showErrorDialog(AppLocalizations.of(context)!.error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveLoginState(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
  }

  Future<void> _fetchUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');

      if (username != null) {
        final response = await http.get(Uri.parse(
            'https://mtqlvltkr5.execute-api.us-east-1.amazonaws.com/userlambda?Username=$username'));

        if (response.statusCode == 200) {
          List<UserInfo> userInfoList = userInfoFromJson(response.body);
          setState(() {
            _userInfo = userInfoList.isNotEmpty ? userInfoList[0] : null;
          });
        } else {
          _showErrorDialog(AppLocalizations.of(context)!.fail_retrieve_info);
        }
      } else {
        _showErrorDialog(AppLocalizations.of(context)!.user_notfound_pref);
      }
    } catch (e) {
      _showErrorDialog(AppLocalizations.of(context)!.fail_fetch_info);
    }
  }

  Future<void> _saveUserInfoToPreferences(UserInfo userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', userInfo.fullName);
    await prefs.setString('schoolName', userInfo.schoolName);
    await prefs.setString('class', userInfo.classId);
    await prefs.setString('gender', userInfo.gender);
  }

  Future<void> _changeLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    // Update the app's locale (this should be handled by the main app)
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.login_failed),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.eco,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    AppLocalizations.of(context)!.welcome_back,
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    AppLocalizations.of(context)!.tagline,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  _buildTextField(_usernameController, Icons.person_outline,
                      AppLocalizations.of(context)!.username),
                  const SizedBox(height: 20.0),
                  _buildTextField(_passwordController, Icons.lock_outline,
                      AppLocalizations.of(context)!.password,
                      isPassword: true),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        '${AppLocalizations.of(context)!.forgot_password}?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hintText,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}