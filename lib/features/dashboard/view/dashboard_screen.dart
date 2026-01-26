// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: SingleChildScrollView(
//             child: Column(
//               spacing: 12,
//               children: [
//                 // -------------------Doctor Details --------------
//                 ShadCard(
//                   padding: EdgeInsets.all(12),
//                   child: Row(
//                     spacing: 12,
//                     children: [
//                       CircleAvatar(
//                         radius: 35,
//                         backgroundImage: NetworkImage(
//                           "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Dr. Alex Riveira",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "Cardiologist",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 16,
//                                 color: Colors.teal,
//                               ),
//                             ),

//                             Text(
//                               "WIO ID: XXXXXXXXX",
//                               style: GoogleFonts.exo2(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ----------------- Appointment Summary -----------
//                 Row(
//                   spacing: 12,
//                   children: [
//                     Expanded(
//                       child: ShadCard(
//                         padding: EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,

//                           children: [
//                             Text(
//                               "Patients",
//                               style: GoogleFonts.exo2(fontSize: 16),
//                             ),

//                             Text(
//                               "1256",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),

//                             Text(
//                               "Total",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 12,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     Expanded(
//                       child: ShadCard(
//                         padding: EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Today",
//                               style: GoogleFonts.exo2(fontSize: 16),
//                             ),

//                             Text(
//                               "12",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),

//                             Text(
//                               "Scheduled",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 12,
//                                 color: Colors.teal,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     Expanded(
//                       child: ShadCard(
//                         padding: EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Pending",
//                               style: GoogleFonts.exo2(fontSize: 16),
//                             ),

//                             Text(
//                               "4",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),

//                             Text(
//                               "Critical",
//                               style: GoogleFonts.exo2(
//                                 fontSize: 12,
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // ----------- Today's Patient Roaster -------------
//                 Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Today's Patients Roaster",
//                           style: GoogleFonts.exo2(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         Text(
//                           "See All",
//                           style: GoogleFonts.exo2(
//                             fontSize: 16,
//                             color: Colors.teal,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),

//                     //
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return ShadCard(
//                           padding: EdgeInsets.all(12),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               CircleAvatar(radius: 35),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Sarah Jenkins",
//                                     style: GoogleFonts.exo2(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "42y . Female . Hypertension",
//                                     style: GoogleFonts.exo2(fontSize: 12),
//                                   ),
//                                 ],
//                               ),

//                               ShadButton(
//                                 backgroundColor: Colors.teal,
//                                 child: Text(
//                                   "View",
//                                   style: GoogleFonts.exo2(fontSize: 12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ----------------------------- 22222222222222222 --------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Cardiologist",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          "WIO ID: XXXXXXXXX",
                          style: GoogleFonts.inter(
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
                  child: _buildStatCard(
                    context,
                    icon: Icons.people_outline,
                    count: "1,256",
                    label: "Total Patients",
                    color: Color(0xFF8B5CF6),
                    lightColor: isDark ? Color(0xFF312E81) : Color(0xFFF3E8FF),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.event_available,
                    count: "12",
                    label: "Today",
                    color: Color(0xFF0D9488),
                    lightColor: isDark ? Color(0xFF134E4A) : Color(0xFFCCFBF1),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
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
                  "Today's Appointments",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: GoogleFonts.inter(
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
            ...List.generate(5, (index) {
              final patients = [
                {
                  "name": "Sarah Jenkins",
                  "age": "42",
                  "gender": "F",
                  "condition": "Hypertension",
                },
                {
                  "name": "Michael Chen",
                  "age": "35",
                  "gender": "M",
                  "condition": "Diabetes",
                },
                {
                  "name": "Emma Wilson",
                  "age": "28",
                  "gender": "F",
                  "condition": "Asthma",
                },
                {
                  "name": "Robert Taylor",
                  "age": "56",
                  "gender": "M",
                  "condition": "Heart Disease",
                },
                {
                  "name": "Lisa Anderson",
                  "age": "49",
                  "gender": "F",
                  "condition": "Cholesterol",
                },
              ];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        isDark
                            ? Border.all(color: Color(0xFF334155), width: 1)
                            : null,
                    boxShadow:
                        isDark
                            ? null
                            : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF0F766E) : Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            patients[index]["name"]![0],
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Color(0xFF0D9488),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patients[index]["name"]!,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    isDark ? Colors.white : Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                _buildInfoChip(
                                  context,
                                  "${patients[index]["age"]}y",
                                ),
                                SizedBox(width: 6),
                                _buildInfoChip(
                                  context,
                                  patients[index]["gender"]!,
                                ),
                                SizedBox(width: 6),
                                _buildInfoChip(
                                  context,
                                  patients[index]["condition"]!,
                                  isCondition: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF0D9488),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          "View",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    required Color lightColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Color(0xFF334155), width: 1) : null,
        boxShadow:
            isDark
                ? null
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? Color(0xFF94A3B8) : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String text, {
    bool isCondition = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isCondition
                ? (isDark ? Color(0xFF713F12) : Color(0xFFFEF3C7))
                : (isDark ? Color(0xFF334155) : Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          color:
              isCondition
                  ? (isDark ? Color(0xFFFDE68A) : Color(0xFF92400E))
                  : (isDark ? Color(0xFFCBD5E1) : Color(0xFF6B7280)),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
