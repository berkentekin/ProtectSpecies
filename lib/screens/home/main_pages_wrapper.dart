import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/home/home.dart';
import 'package:flutterapp/screens/home/identify.dart';
import 'package:flutterapp/screens/home/profile.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:tflite/tflite.dart';
import './organizatinal_page.dart';

import 'package:provider/provider.dart';

Widget settingsDrawer(BuildContext context) {
  final AuthanticateServ _auth = AuthanticateServ();

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Center(
              child: Text(
            'Settings',
            textScaleFactor: 2.0,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          decoration: BoxDecoration(
            color: Color(0xFF103A3E),
          ),
        ),
        ListTile(
          title: Text('Deneme Sayfası'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrgAccount(),
              ),
            );
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {},
        ),
        ListTile(title: Text('Item 3'), onTap: () {}),
        SizedBox(height: 300.0),
        TextButton.icon(
          icon: Icon(Icons.person),
          onPressed: () async {
            await _auth.signOut();
          },
          label: Text("Log Out"),
        ),
      ],
    ),
  );
}

class MainPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

int selectedIndex2 = 1;

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  void pageChanged(int index) {
    setState(() {
      selectedIndex = index;
      selectedIndex2 = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );
  int selectedIndex = 1;

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Page1Camera(),
        Home(),
        Profile(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      selectedIndex = index;
      selectedIndex2 = index;
      pageController.jumpToPage(index);
    });
  }

  bool isloading = false;

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/modelv3.tflite",
      labels: "assets/labels3.txt",
    );
  }

  void initState() {
    super.initState();
    isloading = true;
    loadModel().then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: (selectedIndex != 0)
          ? Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xFF103A3E),
              ),
              child: BottomNavigationBar(
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.white,
                currentIndex: selectedIndex,
                onTap: (index) {
                  bottomTapped(index);
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera_alt_outlined),
                    label: 'Identify',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profile',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
