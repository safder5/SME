import 'package:ashwani/Screens/home.dart';
import 'package:ashwani/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'Screens/purchase.dart';
import 'Screens/sales.dart';

class LandingBypass extends StatefulWidget {
  const LandingBypass({super.key});

  @override
  State<LandingBypass> createState() => _LandingBypassState();
}

class _LandingBypassState extends State<LandingBypass> {
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);
    List<Widget> buildScreens() {
      return [
        const HomePage(),
        const SalesPage(),
        const PurchasePage(),
      ];
    } // const BOM()

    List<PersistentBottomNavBarItem> navBarItems() {
      return [
        PersistentBottomNavBarItem(
            inactiveIcon: Icon(
              LineIcons.home,
              color: b32,
            ),
            icon: Icon(
              LineIcons.home,
              color: blue,
            ),
            title: 'Home',
            activeColorPrimary: blue,
            activeColorSecondary: blue),
        PersistentBottomNavBarItem(
            inactiveIcon: Icon(
              LineIcons.sellcast,
              color: b32,
            ),
            icon: Icon(
              LineIcons.sellcast,
              color: blue,
            ),
            title: 'Sales',
            activeColorPrimary: blue,
            activeColorSecondary: blue),
        PersistentBottomNavBarItem(
            inactiveIcon: Icon(
              LineIcons.shoppingBag,
              color: b32,
            ),
            icon: Icon(
              LineIcons.shoppingBag,
              color: blue,
            ),
            title: 'Purchase',
            activeColorPrimary: blue,
            activeColorSecondary: blue),
        // PersistentBottomNavBarItem(
        //     inactiveIcon: Icon(
        //       LineIcons.pieChart,
        //       color: b32,
        //     ),
        //     icon: Icon(
        //       LineIcons.pieChart,
        //       color: blue,
        //     ),
        //     title: 'BOM',
        //     activeColorPrimary: blue,
        //     activeColorSecondary: blue)
      ];
    }

    return PersistentTabView(
      context,
      screens: buildScreens(),
      controller: controller,
      items: navBarItems(),
      backgroundColor: Colors.white,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardShows: true,
      navBarHeight: 66,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        duration: Duration(milliseconds: 400),
      ),
      decoration: const NavBarDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0))),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
