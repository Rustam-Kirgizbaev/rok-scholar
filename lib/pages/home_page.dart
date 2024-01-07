import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rok_scholar/pages/bookmark_page.dart';
import 'package:rok_scholar/pages/practice_page.dart';
import 'package:rok_scholar/pages/text_search_page.dart';
import 'package:rok_scholar/pages/voice_search_page.dart';
import 'package:rok_scholar/widgets/app_bars.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = <Widget>[
    TextSearchPage(),
    Stt(),
    PracticePage(),
    BookmarkPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildMainAppBar(context, "RoK Scholar", _scaffoldKey),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage(
                        'assets/opodda.jpg'), // Image from assets
                    radius: 30.r, // Adjust the radius for size
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'RoK Scholar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 24.h,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/question.svg',
                width: 24.w,
                height: 24.h,
                color: Theme.of(context).colorScheme.surface,
              ),
              title: Text(
                'How to use',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 16.sp),
              ),
              onTap: () {
                // Update the state of the app
                _launchUrl('https://telegra.ph/How-to-use-RoK-Scolar-12-01');
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/share.svg',
                width: 24.w,
                height: 24.h,
                color: Theme.of(context).colorScheme.surface,
              ),
              title: Text(
                'Share us',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 16.sp),
              ),
              onTap: () {
                // Update the state of the app
                // need to change the url
                const iOSurl = 'https://telegra.ph/How-to-use-RoK-Scolar-12-01';
                const androidUrl =
                    'https://telegra.ph/How-to-use-RoK-Scolar-12-01';
                _launchUrl(Platform.isIOS ? iOSurl : androidUrl);
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/star.svg',
                width: 24.w,
                height: 24.h,
                color: Theme.of(context).colorScheme.surface,
              ),
              title: Text(
                'Rate us',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 16.sp),
              ),
              onTap: () {
                // Update the state of the app
                const iOSurl = 'https://telegra.ph/How-to-use-RoK-Scolar-12-01';
                const androidUrl =
                    'https://telegra.ph/How-to-use-RoK-Scolar-12-01';
                _launchUrl(Platform.isIOS ? iOSurl : androidUrl);
              },
            ),
            // Add other ListTile items...
            SizedBox(
              height: 300.h,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 24.w,
                    ),
                    IconButton(
                        onPressed: () {
                          _launchUrl('https://discord.gg/bZz84wjBdu');
                        },
                        icon: Icon(
                          Icons.discord,
                          size: 48.h,
                          color: const Color(0xFF7289d9),
                        )),
                    IconButton(
                        onPressed: () {
                          _launchUrl('https://t.me/rok_scholar');
                        },
                        icon: Icon(
                          Icons.telegram,
                          size: 48.h,
                          color: Colors.blue,
                        )),
                    SizedBox(
                      width: 24.w,
                    )
                  ],
                ),
                Text(
                  'Join communities',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 14.sp),
                )
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 24.w,
              height: 24.h,
              color: _selectedIndex == 0
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Text Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/microphone.svg',
              width: 24.w,
              height: 24.h,
              color: _selectedIndex == 1
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Voice Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bolt.svg',
              width: 24.w,
              height: 24.h,
              color: _selectedIndex == 2
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Prepare',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              width: 24.w,
              height: 24.h,
              color: _selectedIndex == 3
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.tertiary,
            ),
            label: 'Bookmarks',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
