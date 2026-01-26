import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            // -------------------Doctor Details --------------
            ShadCard(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(radius: 25),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Dr. Alex Riveira",
                          style: GoogleFonts.exo2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
