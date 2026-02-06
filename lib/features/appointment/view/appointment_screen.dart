import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _searchController = TextEditingController();

  // Demo data (replace with Provider/API)
  final List<Map<String, dynamic>> _latestAppointments = [
    {
      "name": "Ayesha Rahman",
      "id": "WIO-PT-01924",
      "date": "12 Feb 2026",
      "time": "10:30 AM",
      "type": "Instant Video",
      "status": "Pending",
      "payment": "Unpaid",
    },
    {
      "name": "Mahfuz Ahmed",
      "id": "WIO-PT-01581",
      "date": "12 Feb 2026",
      "time": "12:00 PM",
      "type": "Appointment",
      "status": "Confirmed",
      "payment": "Paid",
    },
    {
      "name": "Nusrat Jahan",
      "id": "WIO-PT-02210",
      "date": "13 Feb 2026",
      "time": "09:15 AM",
      "type": "In Clinic",
      "status": "Confirmed",
      "payment": "Paid",
    },
  ];

  final List<Map<String, dynamic>> _videoHistory = [
    {
      "name": "Raihan Kabir",
      "id": "WIO-PT-01077",
      "date": "10 Feb 2026",
      "time": "08:40 PM",
      "duration": "12m 18s",
      "status": "Completed",
    },
    {
      "name": "Tasnim Islam",
      "id": "WIO-PT-02133",
      "date": "09 Feb 2026",
      "time": "06:05 PM",
      "duration": "09m 02s",
      "status": "Completed",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.isDarkMode;

    final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
    final bgBottom = isDark ? const Color(0xFF060A12) : const Color(0xFFFFFFFF);

    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.65);

    TextStyle titleStyle(double size) => GoogleFonts.exo(
      fontWeight: FontWeight.w800,
      fontSize: size,
      letterSpacing: -0.2,
    );

    TextStyle sectionStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w800, fontSize: size);

    TextStyle bodyStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);

    BoxDecoration cardDecoration() {
      return BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.38)
                    : Colors.black.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      );
    }

    InputDecoration searchDecoration() {
      return InputDecoration(
        hintText: "Search by patient name or ID",
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(LucideIcons.search, size: 18),
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color:
                isDark
                    ? Colors.white.withOpacity(0.18)
                    : Colors.black.withOpacity(0.12),
          ),
        ),
      );
    }

    Color chipBg(String key) {
      final s = key.toLowerCase();
      if (s.contains("pending"))
        return Colors.orange.withOpacity(isDark ? 0.18 : 0.12);
      if (s.contains("confirm"))
        return Colors.green.withOpacity(isDark ? 0.18 : 0.12);
      if (s.contains("complete"))
        return Colors.blue.withOpacity(isDark ? 0.18 : 0.12);
      if (s.contains("paid"))
        return Colors.green.withOpacity(isDark ? 0.18 : 0.12);
      if (s.contains("unpaid"))
        return Colors.red.withOpacity(isDark ? 0.18 : 0.12);
      return Colors.blueGrey.withOpacity(isDark ? 0.18 : 0.12);
    }

    Color chipBorder(String key) {
      final s = key.toLowerCase();
      if (s.contains("pending"))
        return Colors.orange.withOpacity(isDark ? 0.35 : 0.25);
      if (s.contains("confirm"))
        return Colors.green.withOpacity(isDark ? 0.35 : 0.25);
      if (s.contains("complete"))
        return Colors.blue.withOpacity(isDark ? 0.35 : 0.25);
      if (s.contains("paid"))
        return Colors.green.withOpacity(isDark ? 0.35 : 0.25);
      if (s.contains("unpaid"))
        return Colors.red.withOpacity(isDark ? 0.35 : 0.25);
      return Colors.blueGrey.withOpacity(isDark ? 0.35 : 0.25);
    }

    Color chipText(String key) {
      if (isDark) return Colors.white.withOpacity(0.92);
      final s = key.toLowerCase();
      if (s.contains("pending")) return Colors.orange.shade900;
      if (s.contains("confirm")) return Colors.green.shade900;
      if (s.contains("complete")) return Colors.blue.shade900;
      if (s.contains("paid")) return Colors.green.shade900;
      if (s.contains("unpaid")) return Colors.red.shade900;
      return Colors.blueGrey.shade900;
    }

    Widget pillChip(String text, IconData icon, {String? colorKey}) {
      final key = colorKey ?? text;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: chipBg(key),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: chipBorder(key)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: chipText(key)),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.exo(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: chipText(key),
              ),
            ),
          ],
        ),
      );
    }

    Widget avatarCircle(String name) {
      final parts = name.trim().split(RegExp(r"\s+"));
      final initials =
          parts.isEmpty
              ? "P"
              : parts
                  .take(2)
                  .map((e) => e.isNotEmpty ? e[0] : "")
                  .join()
                  .toUpperCase();
      return Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Text(
            initials.isEmpty ? "P" : initials,
            style: GoogleFonts.exo(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
      );
    }

    Widget appointmentCard(Map<String, dynamic> a) {
      final status = (a["status"] ?? "").toString();
      final payment = (a["payment"] ?? "").toString();
      final type = (a["type"] ?? "").toString();

      return Container(
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  avatarCircle(a["name"] ?? "Patient"),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a["name"] ?? "",
                          style: bodyStyle(
                            15,
                          ).copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${a["id"] ?? ""} • ${a["date"] ?? ""} • ${a["time"] ?? ""}",
                          style: bodyStyle(12).copyWith(color: subtleText),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.04),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.85)
                                : Colors.black.withOpacity(0.75),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  pillChip(type, LucideIcons.badgeCheck, colorKey: "confirmed"),
                  pillChip(status, LucideIcons.clock3, colorKey: status),
                  pillChip(payment, LucideIcons.creditCard, colorKey: payment),
                ],
              ),
              const SizedBox(height: 12),
              status.toLowerCase().contains("pending")
                  ? Row(
                    children: [
                      Expanded(
                        child: ShadButton(
                          width: double.infinity,
                          backgroundColor: Colors.green,

                          onPressed: () {},
                          child: Text(
                            "Approve",

                            style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),

                      Expanded(
                        child: ShadButton(
                          width: double.infinity,
                          backgroundColor: Colors.red,

                          onPressed: () {},
                          child: Text(
                            "Reject",

                            style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  )
                  : ShadButton(
                    width: double.infinity,
                    backgroundColor: Colors.teal,
                    onPressed: () {},
                    child: Text(
                      "Manage",
                      style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                    ),
                  ),
            ],
          ),
        ),
      );
    }

    Widget videoCard(Map<String, dynamic> v) {
      return Container(
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              avatarCircle(v["name"] ?? "Patient"),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v["name"] ?? "",
                      style: bodyStyle(
                        15,
                      ).copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${v["id"] ?? ""} • ${v["date"] ?? ""} • ${v["time"] ?? ""}",
                      style: bodyStyle(12).copyWith(color: subtleText),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        pillChip(
                          "Duration: ${v["duration"] ?? "-"}",
                          LucideIcons.timer,
                          colorKey: "completed",
                        ),
                        pillChip(
                          v["status"] ?? "Completed",
                          LucideIcons.video,
                          colorKey: "completed",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04),
                    border: Border.all(color: borderColor),
                  ),
                  child: const Icon(LucideIcons.eye, size: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Filter appointments by search (name/id)
    final q = _searchController.text.trim().toLowerCase();
    final filtered =
        _latestAppointments.where((a) {
          if (q.isEmpty) return true;
          final name = (a["name"] ?? "").toString().toLowerCase();
          final id = (a["id"] ?? "").toString().toLowerCase();
          return name.contains(q) || id.contains(q);
        }).toList();

    final total = _latestAppointments.length;
    final pending =
        _latestAppointments
            .where(
              (e) => (e["status"] ?? "").toString().toLowerCase().contains(
                "pending",
              ),
            )
            .length;
    final expectedRevenue = "৳ ${total * 500}"; // demo

    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments", style: titleStyle(20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // 1) Booked Appointments (header + search + stats column-wise)
                // =========================================================
                Container(
                  decoration: cardDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : Colors.black.withOpacity(0.04),
                              ),
                              child: Icon(
                                LucideIcons.clipboardList,
                                size: 18,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.88)
                                        : Colors.black.withOpacity(0.82),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Booked Appointments",
                                    style: sectionStyle(18),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "View and manage all your confirmed and pending appointments.",
                                    style: bodyStyle(
                                      13,
                                    ).copyWith(color: subtleText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: searchDecoration(),
                          style: bodyStyle(14),
                        ),
                        const SizedBox(height: 14),

                        // Stats in COLUMN (as you asked)
                        Container(
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.04)
                                    : const Color(0xFFF3F4F8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            children: [
                              _StatRow(
                                isDark: isDark,
                                borderColor: borderColor,
                                subtleText: subtleText,
                                title: "Total appointments",
                                value: "$total",
                                icon: LucideIcons.layers,
                                accent: Colors.blue,
                              ),
                              _DividerLine(borderColor: borderColor),
                              _StatRow(
                                isDark: isDark,
                                borderColor: borderColor,
                                subtleText: subtleText,
                                title: "Pending approvals",
                                value: "$pending",
                                icon: LucideIcons.clock3,
                                accent: Colors.orange,
                              ),
                              _DividerLine(borderColor: borderColor),
                              _StatRow(
                                isDark: isDark,
                                borderColor: borderColor,
                                subtleText: subtleText,
                                title: "Expected revenue",
                                value: expectedRevenue,
                                icon: LucideIcons.badgeDollarSign,
                                accent: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =========================================================
                // 2) Latest Appointments (separate section)
                // =========================================================
                Text("Latest appointments", style: sectionStyle(18)),
                const SizedBox(height: 10),

                if (filtered.isEmpty)
                  Container(
                    decoration: cardDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "No appointments found for your search.",
                        style: bodyStyle(13).copyWith(color: subtleText),
                      ),
                    ),
                  ),

                for (final a in filtered) ...[
                  appointmentCard(a),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 16),

                // =========================================================
                // 3) Video Call History (separate section)
                // =========================================================
                Text("Video call history", style: sectionStyle(18)),
                const SizedBox(height: 10),

                if (_videoHistory.isEmpty)
                  Container(
                    decoration: cardDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "No video call history yet.",
                        style: bodyStyle(13).copyWith(color: subtleText),
                      ),
                    ),
                  ),

                for (final v in _videoHistory) ...[
                  videoCard(v),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Small internal helpers (kept minimal and only for the stats separators/rows)
class _DividerLine extends StatelessWidget {
  final Color borderColor;
  const _DividerLine({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: borderColor);
  }
}

class _StatRow extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final Color subtleText;
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatRow({
    required this.isDark,
    required this.borderColor,
    required this.subtleText,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: accent.withOpacity(isDark ? 0.14 : 0.10),
              border: Border.all(
                color: accent.withOpacity(isDark ? 0.25 : 0.18),
              ),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.exo(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: subtleText,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.exo(fontSize: 15, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
