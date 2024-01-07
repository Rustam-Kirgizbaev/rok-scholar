import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pages/settings_screen.dart';

AppBar buildAppBarWithBackAndSettings(BuildContext context, String title,
    [bool isSettingsEnabled = true]) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.background,
    centerTitle: true,
    title: Text(title),
    leading: IconButton(
      icon: SvgPicture.asset(
        'assets/icons/back.svg',
        height: 24.h,
        width: 24.w,
        color: Theme.of(context).colorScheme.surface,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: isSettingsEnabled
        ? [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/settings.svg',
                color: Theme.of(context).colorScheme.surface,
                height: 24.h,
                width: 24.w,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ]
        : [],
  );
}

AppBar buildMainAppBar(
    BuildContext context, String title, GlobalKey<ScaffoldState> _scaffoldKey) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Text(title),
    centerTitle: true,
    leading: IconButton(
      icon: SvgPicture.asset(
        'assets/icons/menu.svg',
        height: 24.h,
        width: 24.w,
        color: Theme.of(context).colorScheme.surface,
      ),
      onPressed: () {
        _scaffoldKey.currentState?.openDrawer();
      },
    ),
    actions: [
      IconButton(
        icon: SvgPicture.asset(
          'assets/icons/settings.svg',
          color: Theme.of(context).colorScheme.surface,
          height: 24.h,
          width: 24.w,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      ),
    ],
  );
}
