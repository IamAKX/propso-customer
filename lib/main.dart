import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propertycp_customer/firebase_options.dart';
import 'package:propertycp_customer/models/user_model.dart';
import 'package:propertycp_customer/screens/home_container/home_container.dart';
import 'package:propertycp_customer/screens/onboarding/login_screen.dart';
import 'package:propertycp_customer/services/api_service.dart';
import 'package:propertycp_customer/utils/preference_key.dart';
import 'package:propertycp_customer/utils/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/appIntro/app_intro_screen.dart';
import 'services/storage_service.dart';
import 'utils/colors.dart';

late SharedPreferences prefs;
UserModel? userModel;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  if (prefs.getInt(SharedpreferenceKey.userId) != null) {
    log('User found in cache, fething user details');
    userModel =
        await ApiProvider().getUserById(SharedpreferenceKey.getUserId());
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApiProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StorageProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PropertyCP',
        theme: ThemeData(
          useMaterial3: false,
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(secondary),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
            background: scaffoldBackgroundColor,
            primary: primary,
            secondary: secondary,
          ),
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)
                  .apply(
            bodyColor: textColorDark,
            displayColor: textColorDark,
          ),
        ),
        home: getHomeScreen(),
        onGenerateRoute: NavRoute.generatedRoute,
      ),
    );
  }

  getHomeScreen() {
    if (prefs.getBool(SharedpreferenceKey.firstTimeAppOpen) ?? true) {
      prefs.setBool(SharedpreferenceKey.firstTimeAppOpen, false);
      return const AppIntroScreen();
    } else if (userModel == null || userModel?.id == null) {
      return const LoginScreen();
    }
    return const HomeContainer();
  }
}
