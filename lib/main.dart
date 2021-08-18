import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_page.dart';

// -----------------------------------------------------------------------------
// FlexColorScheme Simple Custom Theme Example.
//
// This example shows how you can use define a few colors, use FlexColorScheme
// to theme your app with them and also define other FlexColorScheme theme
// properties and how to use a GoogleFonts based font as the overall default
// font for your theme.
// -----------------------------------------------------------------------------

void main() => runApp(const DemoApp());

// For our custom scheme we will define primary and secondary colors, but no
// variant or other colors.
final FlexSchemeColor _mySchemeLight = FlexSchemeColor.from(
  primary: const Color(0xFF3B5997),
  // If you do not want to define secondary, primaryVariant and
  // secondaryVariant, error and appBar colors you do not have to,
  // they will get defined automatically.
  //
  // Here we do define a secondary color, but if you don't it will get a
  // default shade based on the primary color.
  secondary: const Color(0xFFFB8123),
);

// This is custom defined matching dark mode colors, but below we also show
// how to base it of the light color scheme instead as well.
final FlexSchemeColor _mySchemeDark = FlexSchemeColor.from(
  primary: const Color(0xFF8B9DC3),
  secondary: const Color(0xFFFCB075),
);

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlexColorScheme',
      // Define the light theme for the app, based on defined colors.
      theme: FlexColorScheme.light(
        colors: _mySchemeLight,
        surfaceStyle: FlexSurface.medium,
        appBarStyle: FlexAppBarStyle.primary,
        appBarElevation: 0,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: false,
        swapColors: false,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // Set the default font for the ThemeData using GoogleFonts.
        fontFamily: GoogleFonts.lato().fontFamily,
      ).toTheme,
      // Define the dark theme for the app, based on custom colors.
      darkTheme: FlexColorScheme.dark(
        // If you want to base the dark scheme on your light colors, this is
        // a nice shortcut if you do not want to design your dark theme.
        // The whiteBlend for the desaturation of the light theme colors
        // defaults to 35%, you can try other values too, here eg 30.
        colors: _mySchemeLight.toDark(30),
        // If you want to use the defined custom dark colors, just use them:
        // colors: _mySchemeDark,
        surfaceStyle: FlexSurface.strong,
        appBarStyle: FlexAppBarStyle.background,
        appBarElevation: 0,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: false,
        swapColors: false,
        darkIsTrueBlack: false,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.lato().fontFamily,
      ).toTheme,
      // Use the above dark or light theme based on active themeMode below.
      // Toggle in code here, or set to system to toggle with device.
      themeMode: ThemeMode.system,
      // This simple example app has only one page.
      home: HomePage(),
    );
  }
}
