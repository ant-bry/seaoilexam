import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seaoil/gen/colors.gen.dart';

class CustomThemeData {
  static ThemeData build({Brightness brightness = Brightness.dark}) {
    final ThemeData baseThemeData = ThemeData.light();

    final ColorScheme colorScheme = ColorScheme(
      primary: ColorName.deepBlue,
      background: Colors.white,
      brightness: brightness,
      error: Colors.red,
      secondary: ColorName.deepBlue,
      primaryContainer: ColorName.darkBlue,
      secondaryContainer: ColorName.darkBlue,
      surface: Colors.white,
      onBackground: ColorName.deepBlue,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: ColorName.deepBlue,
    );

    final TextTheme textTheme = GoogleFonts.openSansTextTheme().copyWith(
      bodyText2: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
      bodyText1: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
      headline5: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
      headline1: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
      subtitle2: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
      caption: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
      headline6: GoogleFonts.openSans(
        color: ColorName.deepBlack,
      ),
    );

    // final appBarTextTheme = GoogleFonts.openSansTextTheme().copyWith(
    //   headline6: GoogleFonts.openSans(
    //     color: Colors.white,
    //     fontSize: 16,
    //   ),
    // );

    final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );

    return baseThemeData.copyWith(
      scaffoldBackgroundColor: colorScheme.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: colorScheme.primary,
      brightness: brightness,
      errorColor: colorScheme.error,
      indicatorColor: colorScheme.secondary,
      toggleableActiveColor: colorScheme.primary,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      dialogTheme: baseThemeData.dialogTheme.copyWith(
        shape: cardShape,
      ),
      appBarTheme: AppBarTheme(
        color: ColorName.deepBlue,
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        colorScheme: colorScheme,
        buttonColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        height: 45,
      ),
      cardTheme: CardTheme(
        shape: cardShape,
        clipBehavior: Clip.antiAlias,
      ),
      colorScheme: colorScheme,
    );
  }
}
