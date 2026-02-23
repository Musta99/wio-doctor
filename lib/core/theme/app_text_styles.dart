import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle title(double size) =>
      GoogleFonts.exo(fontWeight: FontWeight.w800, fontSize: size);

  static TextStyle section(double size) =>
      GoogleFonts.exo(fontWeight: FontWeight.w800, fontSize: size);

  static TextStyle body(double size) =>
      GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);
}
