import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rok_scholar/pages/home_page.dart';

import 'models/theme_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  RequestConfiguration requestConfiguration =
      RequestConfiguration(testDeviceIds: ["E67B4C7A6739AD276C3AF221C19C3846"]);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: const RoKScholar(),
      ),
    );
  });
}

class RoKScholar extends StatelessWidget {
  const RoKScholar({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return ChangeNotifierProvider(
          create: (_) => ThemeModel(), // Provide the ThemeModel
          child: Consumer<ThemeModel>(
            builder: (context, themeModel, _) {
              return MaterialApp(
                  title: 'RoK Scholar',
                  theme: themeModel.currentTheme,
                  debugShowCheckedModeBanner: false,
                  home: HomePage());
            },
          ),
        );
      },
    );
  }
}
