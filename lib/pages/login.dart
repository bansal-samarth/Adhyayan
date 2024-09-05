import 'package:adhyayan/models/userinfo.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:adhyayan/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
          _showErrorDialog('User not found.');
        } else if (data['Password'] == password) {
          // Successful login
          await _saveLoginState(username);
          await _fetchUserInfo();

          if (_userInfo != null) {
            await _saveUserInfoToPreferences(_userInfo!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            _showErrorDialog('Failed to fetch user information.');
          }
        } else {
          _showErrorDialog('Incorrect password.');
        }
      } else {
        _showErrorDialog('An error occurred. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again.');
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
          _showErrorDialog('Failed to retrieve user information.');
        }
      } else {
        _showErrorDialog('Username not found in preferences.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred while fetching user information.');
    }
  }

  Future<void> _saveUserInfoToPreferences(UserInfo userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', userInfo.fullName);
    await prefs.setString('schoolName', userInfo.schoolName);
    await prefs.setString('class', userInfo.classId);
    await prefs.setString('gender', userInfo.gender);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
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
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Learn Today, Lead Tomorrow.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  _buildTextField(
                      _usernameController, Icons.person_outline, 'Username'),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                      _passwordController, Icons.lock_outline, 'Password',
                      isPassword: true),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                        ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String label,
      {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.green[100]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}