// import 'package:flutter/material.dart';

// class ThemeProviderState {
//   final ThemeMode themeMode;
//   final Function(ThemeMode) setThemeMode;

//   ThemeProviderState({required this.themeMode, required this.setThemeMode});

//   bool get isDarkMode => themeMode == ThemeMode.dark;
//   bool get isLightMode => themeMode == ThemeMode.light;
//   bool get isSystemMode => themeMode == ThemeMode.system;
// }

// class ThemeProvider extends InheritedWidget {
//   final ThemeMode themeMode;
//   final Function(ThemeMode) setThemeMode;

//   const ThemeProvider._({
//     required this.themeMode,
//     required this.setThemeMode,
//     required super.child,
//     super.key,
//   });

//   static ThemeProviderState of(BuildContext context) {
//     final ThemeProvider? result =
//         context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
//     assert(result != null, 'No ThemeProvider found in context');
//     return ThemeProviderState(
//       themeMode: result!.themeMode,
//       setThemeMode: result.setThemeMode,
//     );
//   }

//   @override
//   bool updateShouldNotify(ThemeProvider oldWidget) {
//     return themeMode != oldWidget.themeMode;
//   }
// }

// class ThemeProviderWrapper extends StatefulWidget {
//   final Widget child;

//   const ThemeProviderWrapper({super.key, required this.child});

//   @override
//   State<ThemeProviderWrapper> createState() => _ThemeProviderWrapperState();
// }

// class _ThemeProviderWrapperState extends State<ThemeProviderWrapper> {
//   ThemeMode _themeMode = ThemeMode.system;

//   void _setThemeMode(ThemeMode mode) {
//     setState(() {
//       _themeMode = mode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ThemeProvider._(
//       themeMode: _themeMode,
//       setThemeMode: _setThemeMode,
//       child: widget.child,
//     );
//   }
// }

// ------------------------------- 222222222222222222222 --------------------------
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===============================
/// Theme ViewModel (Provider)
/// ===============================
class ThemeViewModel extends ChangeNotifier {
  static const _key = "app_theme_mode"; // store as String: system/light/dark

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// call once on app start
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    _themeMode = _stringToThemeMode(saved);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _themeModeToString(mode));
  }

  // ---------- helpers ----------
  ThemeMode _stringToThemeMode(String? v) {
    switch (v) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      case "system":
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      case ThemeMode.system:
      default:
        return "system";
    }
  }
}

/// ===============================
/// App Wrapper (Provider + init)
/// ===============================
/// Put this above MaterialApp
class ThemeProviderWrapper extends StatelessWidget {
  final Widget child;
  const ThemeProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeViewModel()..init(),
      child: child,
    );
  }
}

/// ===============================
/// Usage in main.dart
/// ===============================
///
/// void main() {
///   runApp(
///     ThemeProviderWrapper(
///       child: const MyApp(),
///     ),
///   );
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     final themeVM = context.watch<ThemeViewModel>();
///
///     return MaterialApp(
///       themeMode: themeVM.themeMode,
///       theme: ThemeData.light(),
///       darkTheme: ThemeData.dark(),
///       home: const HomeScreen(),
///     );
///   }
/// }
///
///
/// ===============================
/// Toggle theme anywhere
/// ===============================
///
/// final themeVM = context.read<ThemeViewModel>();
/// themeVM.setThemeMode(ThemeMode.dark);
///
/// or
///
/// IconButton(
///   icon: Icon(themeVM.isDarkMode ? Icons.sunny : Icons.nights_stay),
///   onPressed: () {
///     themeVM.setThemeMode(
///       themeVM.isDarkMode ? ThemeMode.light : ThemeMode.dark,
///     );
///   },
/// )
