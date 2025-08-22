import 'dart:ui';

import 'package:ecommerce/bloc/category/category_bloc.dart';
import 'package:ecommerce/bloc/home/home_bloc.dart';
import 'package:ecommerce/bloc/auth/auth_bloc.dart';
import 'package:ecommerce/constants/colors.dart';
import 'package:ecommerce/data/model/basket_item.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/screens/card_screen.dart' hide CardItem;
import 'package:ecommerce/screens/category_screen.dart';
import 'package:ecommerce/screens/hom_screen.dart';
import 'package:ecommerce/screens/profile_screen.dart';
import 'package:ecommerce/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getItInit();
  await Hive.initFlutter();
  Hive.registerAdapter(BasketItemAdapter());
  await Hive.openBox<BasketItem>('basketItemBox');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedBottomNavigationIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: CustomColors.primary,
          secondary: CustomColors.secondary,
          surface: CustomColors.backgroundSecondary,
          background: CustomColors.backgroundPrimary,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: CustomColors.textPrimary,
          onBackground: CustomColors.textPrimary,
          error: CustomColors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: CustomColors.backgroundPrimary,
        appBarTheme: const AppBarTheme(
          backgroundColor: CustomColors.backgroundPrimary,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: CustomColors.textPrimary),
          titleTextStyle: TextStyle(
            color: CustomColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: CustomColors.cardBackground,
          selectedItemColor: CustomColors.primary,
          unselectedItemColor: CustomColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 20,
        ),
        cardTheme: CardThemeData(
          color: CustomColors.cardBackground,
          elevation: 8,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: CustomColors.primary.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: CustomColors.primary,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: CustomColors.textPrimary,
            side: BorderSide(color: CustomColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: CustomColors.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: CustomColors.textMuted.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: CustomColors.primary, width: 2),
          ),
          labelStyle: TextStyle(color: CustomColors.textSecondary),
          hintStyle: TextStyle(color: CustomColors.textMuted),
        ),
      ),
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: LoginScreen(),
      ),
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int selectedBottomNavigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: CustomColors.backgroundPrimary,
        body: IndexedStack(
          index: selectedBottomNavigationIndex,
          children: getScreens(),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: CustomColors.backgroundSecondary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                selectedBottomNavigationIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            currentIndex: selectedBottomNavigationIndex,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
                fontFamily: 'SB', fontSize: 10, color: CustomColors.primary),
            unselectedLabelStyle: const TextStyle(
                fontFamily: 'SB', fontSize: 10, color: CustomColors.textMuted),
            selectedItemColor: CustomColors.primary,
            unselectedItemColor: CustomColors.textMuted,
            items: [
              BottomNavigationBarItem(
                activeIcon: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: CustomColors.primary.withOpacity(0.3),
                            spreadRadius: -7,
                            blurRadius: 20,
                            offset: Offset(0, 13)),
                      ],
                    ),
                    child: Image.asset('assets/images/icon_home_active.png',
                        color: CustomColors.primary)),
                label: 'Home',
                icon: Image.asset('assets/images/icon_home.png'),
              ),
              BottomNavigationBarItem(
                activeIcon: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: CustomColors.primary.withOpacity(0.3),
                            spreadRadius: -7,
                            blurRadius: 20,
                            offset: Offset(0, 13)),
                      ],
                    ),
                    child: Image.asset('assets/images/icon_category_active.png',
                        color: CustomColors.primary.withOpacity(1))),
                label: 'Categories',
                icon: Image.asset('assets/images/icon_category.png'),
              ),
              BottomNavigationBarItem(
                activeIcon: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: CustomColors.primary.withOpacity(0.3),
                            spreadRadius: -7,
                            blurRadius: 20,
                            offset: Offset(0, 13)),
                      ],
                    ),
                    child: Image.asset('assets/images/icon_basket_active.png',
                        color: CustomColors.primary.withOpacity(1))),
                label: 'Cart',
                icon: Image.asset('assets/images/icon_basket.png'),
              ),
              BottomNavigationBarItem(
                activeIcon: Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: CustomColors.primary.withOpacity(0.3),
                            spreadRadius: -7,
                            blurRadius: 20,
                            offset: Offset(0, 13)),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/icon_profile_active.png',
                      color: CustomColors.primary.withOpacity(1),
                    )),
                label: 'Profile',
                icon: Image.asset('assets/images/icon_profile.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getScreens() {
    return <Widget>[
      BlocProvider(
        create: (context) => HomeBloc(),
        child: HomeScreen(),
      ),
      BlocProvider(
        create: (context) => CategoryBloc(),
        child: CategoryScreen(),
      ),
      const CardScreen(),
      const ProfileScreen(),
    ];
  }
}
