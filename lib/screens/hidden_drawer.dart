import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'about_page.dart';
import 'home_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> pages = [];

  @override
  void initState() {
    super.initState();

    pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'Home',
              selectedStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
              baseStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 20)),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'About',
              selectedStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
              baseStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 20)),
          const AboutPage())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
        initPositionSelected: 0,
        screens: pages,
        slidePercent: 60,
        backgroundColorMenu: HexColor('#620896'));
  }
}
