import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:rok_scholar/services/ad.service.dart';

import '../models/theme_model.dart';
import '../widgets/app_bars.dart';

// Create a list of supported locales

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, themeModel, _) {
      return Scaffold(
        appBar: buildAppBarWithBackAndSettings(context, "Settings", false),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdService(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark mode",
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(width: 16.w),
                  FlutterSwitch(
                    width: 60.w,
                    height: 30.h,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: themeModel.appTheme == AppThemeEnum.dark,
                    onToggle: (value) {
                      themeModel.toggleTheme();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Advanced search",
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(width: 16.w),
                  FlutterSwitch(
                    width: 60.w,
                    height: 30.h,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: themeModel.advancedSearchEnabled == true,
                    onToggle: (value) {
                      themeModel.setSearchOption(value);
                    },
                  ),
                ],
              ),
              // Add other settings widgets here
            ],
          ),
        ),
      );
    });
  }
}
