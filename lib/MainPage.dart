import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:kicaredfinal/AccountPage.dart';
import 'package:kicaredfinal/AddNotes.dart';
import 'package:kicaredfinal/ListOfNotes.dart';
import 'package:kicaredfinal/SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  late PageController _myPage;
  int selectedPage = 0;
  void initState() {
    super.initState();
    _myPage = PageController(initialPage: 0);
    selectedPage = 0;
  }

  List<IconData> iconlist = [
    Icons.home_outlined,
    Icons.add,
    Icons.person,
  ];
  List<Widget> _currentpage = [
    ListOfNotes(),
    AddNotes(),
    AccountPage(),
  ];
  int _bottomnavindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOTES',
          style: TextStyle(fontFamily: 'Graduate', color: Color(0xff0d47a1)),
        ),
      ),
      body: _currentpage[_bottomnavindex],
     floatingActionButton: FloatingActionButton(
        child: Icon(Icons.sunny),
        onPressed: () {},
        backgroundColor: Color(0xff039be5),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        leftCornerRadius: 30,
        rightCornerRadius: 30,
        gapLocation: GapLocation.center,
        activeColor: Color(0xffe91e63),
        inactiveColor: Color(0xff0d47a1),
        icons: iconlist,
        activeIndex: _bottomnavindex,
        onTap: (index) => setState(() {
          _bottomnavindex = index;
          selectedPage = index;
        }),
      ),
    );
  }
}
