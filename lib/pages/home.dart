import 'package:adhyayan/pages/mcq_selector.dart';
import 'package:adhyayan/pages/notice.dart';
import 'package:adhyayan/pages/profile.dart';
import 'package:adhyayan/pages/schedule.dart';
import 'package:adhyayan/pages/library.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  String? _fullName;
  String? _schoolName;
  String? _className;
  String? _gender;

  final List<IconData> iconList = [
    Icons.home,
    Icons.ondemand_video_rounded,
    Icons.library_books_rounded,
    Icons.person,
  ];

  final List<String> titleList = [
    "Home",
    "Time Table",
    "Resources",
    "Profile",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName');
      _schoolName = prefs.getString('schoolName');
      _className = prefs.getString('class');
      _gender = prefs.getString('gender');
    });
  }

  Widget _getScreen() {
    switch (_bottomNavIndex) {
      case 0:
        return const NoticePage();
      case 1:
        return const SchedulePage();
      case 2:
        return const LibraryPage();
      case 3:
        return _fullName != null &&
                _schoolName != null &&
                _className != null &&
                _gender != null
            ? ProfilePage(
                name: _fullName!,
                schoolName: _schoolName!,
                className: _className!,
                gender: _gender!,
              )
            : const Center(child: CircularProgressIndicator());
      default:
        return const NoticePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => McqSelector(),
          ));
        },
        child: const Icon(
          Icons.book,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
