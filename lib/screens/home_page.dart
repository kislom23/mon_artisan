import 'package:flutter/material.dart';
import 'package:nye_dowola/modules/artisan/Dashbord.dart';
import 'package:nye_dowola/modules/artisan/profile_page.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nye_dowola/modules/artisan/service_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    DashbordPage(),
    ServicePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onTabChange: (newIndex) => setState(() {
            _selectedIndex = newIndex;
          }),
          backgroundColor: const Color.fromARGB(255, 15, 2, 131),
          color: Colors.white,
          activeColor: Colors.orange,
          gap: 5,
          padding: const EdgeInsets.all(18),
          tabs: const [
            GButton(
              icon: Icons.home,
            ),
            GButton(
              icon: Icons.add_business_sharp,
            ),
            GButton(
              icon: Icons.person,
            )
          ],
        ),
      ),
      body: _tabs[_selectedIndex]);
}
