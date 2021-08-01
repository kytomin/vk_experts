import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vk/pages/landing_page.dart';
import 'package:vk/pages/splash_page.dart';
import 'package:vk/providers/expert_provider.dart';
import 'package:vk/providers/newsfeed_provider.dart';
import 'package:vk/themes/theme.dart';
import 'package:vk_login/vk_login.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final savedThemeMode;
  await Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    AdaptiveTheme.getThemeMode().then((value) => savedThemeMode = value)
  ]);
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final VkProvider _vkProvider = VkProvider();
  final savedThemeMode;

  MyApp({required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _vkProvider.init(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return MaterialApp(
              title: 'VK Experts',
              debugShowCheckedModeBanner: false,
              home: SafeArea(child: SplashPage()),
            );

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<VkProvider>.value(value: _vkProvider),
              ChangeNotifierProvider<NewsFeedProvider>(create: (context) => NewsFeedProvider()),
              ChangeNotifierProvider<ExpertProvider>(create: (context) => ExpertProvider()),
            ],
            child: AdaptiveTheme(
              light: kLightThemeData,
              dark: kDarkThemeData,
              initial: savedThemeMode ?? AdaptiveThemeMode.light,
              builder: (theme, darkTheme) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme,
                darkTheme: darkTheme,
                title: 'VK Experts',
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: SafeArea(
                  child: LandingPage(),
                ),
              ),
            ),
          );
        });
  }
}
