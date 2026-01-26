import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 12,
              children: [
                // -------------------Doctor Details --------------
                ShadCard(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    spacing: 12,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. Alex Riveira",
                              style: GoogleFonts.exo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Cardiologist",
                              style: GoogleFonts.exo2(
                                fontSize: 16,
                                color: Colors.teal,
                              ),
                            ),

                            Text(
                              "WIO ID: XXXXXXXXX",
                              style: GoogleFonts.exo2(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ----------------- Appointment Summary -----------
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: ShadCard(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Patients",
                              style: GoogleFonts.exo2(fontSize: 16),
                            ),

                            Text(
                              "1256",
                              style: GoogleFonts.exo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Total",
                              style: GoogleFonts.exo2(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: ShadCard(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today",
                              style: GoogleFonts.exo2(fontSize: 16),
                            ),

                            Text(
                              "12",
                              style: GoogleFonts.exo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Scheduled",
                              style: GoogleFonts.exo2(
                                fontSize: 12,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: ShadCard(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pending",
                              style: GoogleFonts.exo2(fontSize: 16),
                            ),

                            Text(
                              "4",
                              style: GoogleFonts.exo2(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Critical",
                              style: GoogleFonts.exo2(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ----------- Today's Patient Roaster -------------
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Patients Roaster",
                          style: GoogleFonts.exo2(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "See All",
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            color: Colors.teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    //
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ShadCard(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(radius: 35),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sarah Jenkins",
                                    style: GoogleFonts.exo2(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "42y . Female . Hypertension",
                                    style: GoogleFonts.exo2(fontSize: 12),
                                  ),
                                ],
                              ),

                              ShadButton(
                                backgroundColor: Colors.teal,
                                child: Text(
                                  "View",
                                  style: GoogleFonts.exo2(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
