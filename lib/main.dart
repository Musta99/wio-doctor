// import 'package:flutter/material.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/features/bottom_nav_bar/bottom_nav_bar.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ShadApp(debugShowCheckedModeBanner: false, home: BottomNavBar());
//   }
// }

// --------------------- 2222222222222222 ---------------------
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/auth/view/login_screen.dart';

import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';
import 'package:wio_doctor/features/auth/view_model/signup_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProviderWrapper(child: const AppContent());
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewmodel()),
      ],
      builder: (context, child) {
        return ShadApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadZincColorScheme.light(),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme: const ShadZincColorScheme.dark(),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
