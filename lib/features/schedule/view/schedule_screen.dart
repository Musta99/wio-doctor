import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule & Availability',
          style: GoogleFonts.exo(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Theme switcher button - toggles between light and dark
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? LucideIcons.sun : LucideIcons.moon,
            ),
            onPressed: () {
              // Toggle between light and dark mode
              themeProvider.setThemeMode(
                themeProvider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Current Availability Section
                ShadCard(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Availability",
                        style: GoogleFonts.exo(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text("Status: "),
                          SizedBox(width: 8),
                          Chip(
                            label: Text(
                              "Offline",
                              style: GoogleFonts.exo(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),

                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: ShadCard(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.check,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Instant Consultations",
                                      style: GoogleFonts.exo(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ShadCard(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.check,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Appointment Consultations",
                                      style: GoogleFonts.exo(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Available days",
                            style: GoogleFonts.exo(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(label: Text("Monday")),
                              Chip(label: Text("Tuesday")),
                              Chip(label: Text("Wednesday")),
                              Chip(label: Text("Thursday")),
                              Chip(label: Text("Friday")),
                              Chip(label: Text("Saturday")),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
