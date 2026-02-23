import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

class AllAppointmentList extends StatelessWidget {
  const AllAppointmentList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Appointments", style: AppTextStyles.title(20)),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            tooltip: isDark ? "Switch to light" : "Switch to dark",
            icon: Icon(isDark ? LucideIcons.sun : LucideIcons.moon),
            onPressed: () {
              themeProvider.setThemeMode(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(children: [
            
          ],
        ),
        ),
      ),
    );
  }
}
