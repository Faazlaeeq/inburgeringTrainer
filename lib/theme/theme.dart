import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static CupertinoThemeData lightTheme(BuildContext context) {
    return CupertinoThemeData(
      primaryColor: CupertinoColors.systemBlue,
      brightness: Brightness.light,
      textTheme: CupertinoTextThemeData(
        primaryColor: CupertinoColors.black,
        textStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: CupertinoColors.black,
        ),
      ),
    );
  }
}
