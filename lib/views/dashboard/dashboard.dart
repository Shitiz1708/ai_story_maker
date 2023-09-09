import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:ai_story_maker/views/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/text_style.dart';
import '../library/story_type.dart';
import '../profiles/settings.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const StoryCreationScreen(),
    // const CategoriesScreen(),
    const SettingsScreen(),
    // const CommunityScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _widgetOptions[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              iconSize: 20,
              selectedFontSize: 15,
              unselectedFontSize: 15,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: sfBold.copyWith(color: Colors.white),
              unselectedLabelStyle: sfBold.copyWith(color: Colors.grey),
              onTap: _onItemTapped,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: ('Home'),
                    icon: Image.asset(
                      "assets/book 2.png",
                      height: 30,
                      width: 20,
                      fit: BoxFit.contain,
                    )),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: ('Generate'),
                  icon: Image.asset(
                    "assets/document 2.png",
                    height: 30,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                ),
                // BottomNavigationBarItem(
                //   backgroundColor: Theme.of(context).primaryColor,
                //   label: ('Category'),
                //   icon: Image.asset(
                //     "assets/bulb.png",
                //     height: 30,
                //     width: 20,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: ('Profile'),
                  icon: Image.asset(
                    "assets/User Icon.png",
                    height: 30,
                    width: 20,
                    color: Colors.grey,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
