library tftheme;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  @override
  void onInit() {
    super.onInit();

    GetStorage().writeIfNull('darktheme', false);
    _loadCurrentTheme();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    GetStorage().write('darktheme', _darkTheme);
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = GetStorage().read('darktheme') ?? false;
    update();
  }

  ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color(0xffF3F5F6),
    primaryColor: const Color(0xff162938),
    secondaryHeaderColor: const Color.fromRGBO(197, 73, 44, 1),
    disabledColor: const Color(0xFF999999),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: Colors.white,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF69AEA9))),
    colorScheme: const ColorScheme.light(
            primary: Color(0xff162938), secondary: Color(0xFFA8DEEB))
        .copyWith(background: const Color(0xFFF3F3F3))
        .copyWith(error: const Color(0xFFE84D4F)),
    // textTheme: TextTheme(
    //   headline1: sfBold.copyWith(
    //       color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    //   headline2: sfBold.copyWith(
    //       color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
    //   headline3: sfBold.copyWith(
    //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
    //   headline4: sfBold.copyWith(
    //       color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    //   headline5: sfBold.copyWith(
    //       color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
    //   headline6: sfBold.copyWith(
    //       color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
    //   bodyText1: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
    //   bodyText2: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
    //   subtitle1: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
    //   subtitle2: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
    //   caption: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 12, fontWeight: FontWeight.normal),
    //   button: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
    //   overline: sfRegular.copyWith(
    //       color: Colors.black, fontSize: 8, fontWeight: FontWeight.normal),
    // )
  );

  ThemeData dark = ThemeData(
    scaffoldBackgroundColor: const Color(0xff000000),
    primaryColor: const Color(0xff162938),
    secondaryHeaderColor: const Color(0xff162938),
    disabledColor: const Color(0xffa2a7ad),
    brightness: Brightness.dark,
    hintColor: const Color(0xFFbebebe),
    cardColor: Colors.black,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xff162938))),
    colorScheme: const ColorScheme.dark(
            primary: Color(0xff162938), secondary: Color(0xFFA8DEEB))
        .copyWith(background: const Color(0xFF343636))
        .copyWith(error: const Color(0xFFdd3135)),
    // textTheme: TextTheme(
    //   headline1: sfBold.copyWith(
    //       color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    //   headline2: sfBold.copyWith(
    //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    //   headline3: sfBold.copyWith(
    //       color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    //   headline4: sfBold.copyWith(
    //       color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    //   headline5: sfBold.copyWith(
    //       color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
    //   headline6: sfBold.copyWith(
    //       color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
    //   bodyText1: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
    //   bodyText2: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
    //   subtitle1: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
    //   subtitle2: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
    //   caption: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
    //   button: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
    //   overline: sfRegular.copyWith(
    //       color: Colors.white, fontSize: 8, fontWeight: FontWeight.normal),
    //)
  );
}

Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};
