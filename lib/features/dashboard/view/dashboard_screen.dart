import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/dashboard/widgets/appointment_state_card.dart';
import 'package:wio_doctor/features/dashboard/widgets/patient_card.dart';
import 'package:wio_doctor/features/patient/view/patient_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = ThemeProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wio Doctor'),
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
      backgroundColor: isDark ? Colors.black : Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isDark
                          ? [Color(0xFF0D9488), Color(0xFF0F766E)]
                          : [Color(0xFF0D9488), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0D9488).withOpacity(isDark ? 0.2 : 0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. Alex Riveira",
                          style: GoogleFonts.exo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Cardiologist",
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          "WIO ID: XXXXXXXXX",
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: AppointmentStateCard(
                    icon: Icons.people_outline,
                    count: "1,256",
                    label: "Total Patients",
                    color: Color(0xFF8B5CF6),
                    lightColor: isDark ? Color(0xFF312E81) : Color(0xFFF3E8FF),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppointmentStateCard(
                    icon: Icons.event_available,
                    count: "12",
                    label: "Today",
                    color: Color(0xFF0D9488),
                    lightColor: isDark ? Color(0xFF134E4A) : Color(0xFFCCFBF1),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppointmentStateCard(
                    icon: Icons.priority_high,
                    count: "4",
                    label: "Critical",
                    color: Color(0xFFEF4444),
                    lightColor: isDark ? Color(0xFF7F1D1D) : Color(0xFFFEE2E2),
                  ),
                ),
              ],
            ),

            SizedBox(height: 28),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Patient Roaster",
                  style: GoogleFonts.exo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Patient List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) {
                return PatientCard(
                  name: "Sarah Jenkins",
                  sex: "F",
                  age: "50 y",
                  reason: "Hypertension",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PatientDetailsScreen()),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
