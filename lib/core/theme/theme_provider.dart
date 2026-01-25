import 'package:flutter/material.dart';

class ThemeProviderState {
  final ThemeMode themeMode;
  final Function(ThemeMode) setThemeMode;

  ThemeProviderState({required this.themeMode, required this.setThemeMode});

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;
  bool get isSystemMode => themeMode == ThemeMode.system;
}

class ThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) setThemeMode;

  const ThemeProvider._({
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
    super.key,
  });

  static ThemeProviderState of(BuildContext context) {
    final ThemeProvider? result =
        context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'No ThemeProvider found in context');
    return ThemeProviderState(
      themeMode: result!.themeMode,
      setThemeMode: result.setThemeMode,
    );
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

class ThemeProviderWrapper extends StatefulWidget {
  final Widget child;

  const ThemeProviderWrapper({super.key, required this.child});

  @override
  State<ThemeProviderWrapper> createState() => _ThemeProviderWrapperState();
}

class _ThemeProviderWrapperState extends State<ThemeProviderWrapper> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider._(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
      child: widget.child,
    );
  }
}
