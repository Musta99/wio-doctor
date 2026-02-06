// import 'package:flutter/material.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';
// import 'package:wio_doctor/features/appointment/view/appointment_screen.dart';
// import 'package:wio_doctor/features/dashboard/view/dashboard_screen.dart';
// import 'package:wio_doctor/features/profile/view/profile_screen.dart';
// import 'package:wio_doctor/features/schedule/view/schedule_screen.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _currentIndex = 0;

//   List screens = [
//     const DashboardScreen(),
//     const ScheduleScreen(),
//     const AppointmentScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = ThemeProvider.of(context);

//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed, // ✅ important for 4+ items
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.layoutDashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.calendar),
//             label: 'Schedule',
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.stethoscope),
//             label: 'Appointment',
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.user),
//             label: 'Profile',
//           ),
//         ],
//       ),
//       body: screens[_currentIndex],
//     );
//   }
// }

// ------------------- 2222222222222222222 -------------------
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/appointment/view/appointment_screen.dart';
import 'package:wio_doctor/features/dashboard/view/dashboard_screen.dart';
import 'package:wio_doctor/features/profile/view/profile_screen.dart';
import 'package:wio_doctor/features/schedule/view/schedule_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // ✅ only this index will animate
  int _animateIndex = 0;

  final screens = const [
    DashboardScreen(),
    ScheduleScreen(),
    AppointmentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selected =
        isDark
            ? Colors.white.withOpacity(0.92)
            : Colors.black.withOpacity(0.88);
    final unselected =
        isDark
            ? Colors.white.withOpacity(0.55)
            : Colors.black.withOpacity(0.45);

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItemRotateBack(
                index: 0,
                active: _currentIndex == 0,
                animateIndex: _animateIndex,
                icon: LucideIcons.layoutDashboard,
                label: "Dashboard",
                selectedColor: selected,
                unselectedColor: unselected,
                onTap: () => _onTab(0),
              ),
              _NavItemRotateBack(
                index: 1,
                active: _currentIndex == 1,
                animateIndex: _animateIndex,
                icon: LucideIcons.calendar,
                label: "Schedule",
                selectedColor: selected,
                unselectedColor: unselected,
                onTap: () => _onTab(1),
              ),
              _NavItemRotateBack(
                index: 2,
                active: _currentIndex == 2,
                animateIndex: _animateIndex,
                icon: LucideIcons.stethoscope,
                label: "Appointment",
                selectedColor: selected,
                unselectedColor: unselected,
                onTap: () => _onTab(2),
              ),
              _NavItemRotateBack(
                index: 3,
                active: _currentIndex == 3,
                animateIndex: _animateIndex,
                icon: LucideIcons.user,
                label: "Profile",
                selectedColor: selected,
                unselectedColor: unselected,
                onTap: () => _onTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTab(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
      _animateIndex = index; // ✅ only selected item will animate
    });
  }
}

/// Only animates when animateIndex == this item's index
class _NavItemRotateBack extends StatefulWidget {
  final int index;
  final int animateIndex;

  final bool active;
  final IconData icon;
  final String label;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavItemRotateBack({
    required this.index,
    required this.animateIndex,
    required this.active,
    required this.icon,
    required this.label,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  State<_NavItemRotateBack> createState() => _NavItemRotateBackState();
}

class _NavItemRotateBackState extends State<_NavItemRotateBack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rot;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _rot = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 18 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 18 * pi / 180,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 45,
      ),
    ]).animate(_ctrl);
  }

  @override
  void didUpdateWidget(covariant _NavItemRotateBack oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ animate ONLY when THIS item becomes the animateIndex
    final becameAnimated =
        oldWidget.animateIndex != widget.animateIndex &&
        widget.animateIndex == widget.index;

    if (becameAnimated) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? widget.selectedColor : widget.unselectedColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.active ? color.withOpacity(0.10) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Transform.rotate(
                  angle: _rot.value,
                  child: Icon(widget.icon, color: color, size: 22),
                );
              },
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    widget.active
                        ? FontWeight.w800
                        : widget.active
                        ? FontWeight.w700
                        : FontWeight.w600,
                color: color,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}
