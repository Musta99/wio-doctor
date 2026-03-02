// // import 'package:flutter/material.dart';
// // import 'package:shadcn_ui/shadcn_ui.dart';
// // import 'package:wio_doctor/features/bottom_nav_bar/bottom_nav_bar.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ShadApp(debugShowCheckedModeBanner: false, home: BottomNavBar());
// //   }
// // }

// // --------------------- 2222222222222222 ---------------------
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
// import 'package:wio_doctor/features/auth/view/login_screen.dart';

// import 'package:wio_doctor/core/theme/theme_provider.dart';
// import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';
// import 'package:wio_doctor/features/auth/view_model/signup_viewmodel.dart';
// import 'package:wio_doctor/features/bottom_nav_bar/view/bottom_nav_bar.dart';
// import 'package:wio_doctor/features/clinical_review/view_model/clinical_review_view_model.dart';
// import 'package:wio_doctor/features/consultation_fee/view_model/consultation_fee_view_model.dart';
// import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';
// import 'package:wio_doctor/features/digital_prescription/view_model/digital_prescription_view_model.dart';
// import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';
// import 'package:wio_doctor/features/patient_access/view_model/patient_access_view_model.dart';
// import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
// import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';
// import 'package:wio_doctor/features/wio_case_discussion/view_model/case_discussion_view_model.dart';
// import 'package:wio_doctor/view_model/auth_provider.dart';
// import 'package:wio_doctor/view_model/date_picker_view_model.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ThemeProviderWrapper(child: const AppContent());
//   }
// }

// class AppContent extends StatelessWidget {
//   const AppContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = ThemeProvider.of(context);

//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => AuthenticationProvider()..init(),
//         ),
//         ChangeNotifierProvider(create: (context) => SignupViewModel()),
//         ChangeNotifierProvider(create: (context) => LoginViewmodel()),
//         ChangeNotifierProvider(create: (context) => DashboardViewModel()),
//         ChangeNotifierProvider(create: (context) => PatientViewModel()),
//         ChangeNotifierProvider(create: (context) => DatePickerProvider()),
//         ChangeNotifierProvider(create: (context) => ScheduleViewModel()),
//         ChangeNotifierProvider(create: (context) => AppointmentViewModel()),
//         ChangeNotifierProvider(create: (context) => ProfileViewModel()),
//         ChangeNotifierProvider(create: (context) => ConsultationFeeViewModel()),
//         ChangeNotifierProvider(
//           create: (context) => DigitalPrescriptionViewModel(),
//         ),
//         ChangeNotifierProvider(create: (context) => ClinicalReviewViewModel()),
//         ChangeNotifierProvider(create: (context) => CaseDiscussionViewModel()),
//         ChangeNotifierProvider(create: (context) => PatientAccessViewModel()),
//       ],
//       builder: (context, child) {
//         return ShadApp(
//           debugShowCheckedModeBanner: false,
//           themeMode: themeProvider.themeMode,
//           theme: ShadThemeData(
//             brightness: Brightness.light,
//             colorScheme: const ShadZincColorScheme.light(),
//           ),
//           darkTheme: ShadThemeData(
//             brightness: Brightness.dark,
//             colorScheme: const ShadZincColorScheme.dark(),
//           ),
//           home:
//               FirebaseAuth.instance.currentUser != null
//                   ? BottomNavBar()
//                   : LoginScreen(),
//         );
//       },
//     );
//   }
// }


// --------------------------- 22222222222222222222222222 --------------------------------------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// Auth + Core
import 'package:wio_doctor/view_model/auth_provider.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

// Screens
import 'package:wio_doctor/features/auth/view/login_screen.dart';
import 'package:wio_doctor/features/bottom_nav_bar/view/bottom_nav_bar.dart';

// ViewModels
import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';
import 'package:wio_doctor/features/auth/view_model/signup_viewmodel.dart';
import 'package:wio_doctor/features/clinical_review/view_model/clinical_review_view_model.dart';
import 'package:wio_doctor/features/consultation_fee/view_model/consultation_fee_view_model.dart';
import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:wio_doctor/features/digital_prescription/view_model/digital_prescription_view_model.dart';
import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';
import 'package:wio_doctor/features/patient_access/view_model/patient_access_view_model.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';
import 'package:wio_doctor/features/wio_case_discussion/view_model/case_discussion_view_model.dart';
import 'package:wio_doctor/view_model/date_picker_view_model.dart';

// TELEMEDICINE SERVICES (same as patient app structure)
import 'package:wio_doctor/services/local_notification_service.dart';
import 'package:wio_doctor/services/fcm_notification_handler.dart';
import 'package:wio_doctor/services/fcm_token_service.dart';
import 'package:wio_doctor/services/incoming_call_service.dart';

// TELEMEDICINE PROVIDERS
import 'package:wio_doctor/features/telemedicine/view_model/incoming_call_provider.dart';
import 'package:wio_doctor/features/telemedicine/view_model/video_call_provider.dart';
import 'package:wio_doctor/features/telemedicine/view/incoming_call_screen.dart';

/// ============================================
/// GLOBAL NAVIGATOR KEY (for showing calls globally)
/// ============================================
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// ============================================
/// BACKGROUND MESSAGE HANDLER (must be top level)
/// ============================================
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data['type'] == 'telemedicine_call') {
    await FCMNotificationHandler.showCallNotification(message);
  }
}

/// ============================================
/// MAIN
/// ============================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  await LocalNotificationService.init();
  await FCMNotificationHandler.initialize();

  runApp(const MyApp());
}

/// ============================================
/// APP ROOT
/// ============================================
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
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider()..init(),
        ),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewmodel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => PatientViewModel()),
        ChangeNotifierProvider(create: (_) => DatePickerProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleViewModel()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ConsultationFeeViewModel()),
        ChangeNotifierProvider(create: (_) => DigitalPrescriptionViewModel()),
        ChangeNotifierProvider(create: (_) => ClinicalReviewViewModel()),
        ChangeNotifierProvider(create: (_) => CaseDiscussionViewModel()),
        ChangeNotifierProvider(create: (_) => PatientAccessViewModel()),

        /// TELEMEDICINE PROVIDERS
        ChangeNotifierProvider(create: (_) => IncomingCallProvider()),
        ChangeNotifierProvider(create: (_) => VideoCallProvider()),
      ],
      child: ShadApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        themeMode: themeProvider.themeMode,
        theme: ShadThemeData(
          brightness: Brightness.light,
          colorScheme: const ShadZincColorScheme.light(),
        ),
        darkTheme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadZincColorScheme.dark(),
        ),
        home: const AppRoot(),
      ),
    );
  }
}

/// ============================================
/// APP ROOT WITH TELEMEDICINE INITIALIZATION
/// ============================================
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isShowingIncomingCall = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServices();
      _setupIncomingCallListener();
    });
  }

  Future<void> _initializeServices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FCMTokenService.instance.initialize();
      IncomingCallService.instance.startListening();
      debugPrint('✅ Doctor telemedicine services initialized');
    } catch (e) {
      debugPrint('❌ Error initializing services: $e');
    }
  }

  void _setupIncomingCallListener() {
    IncomingCallService.instance.incomingCallStream.listen((callData) {
      if (!mounted || callData == null) return;

      if (_isShowingIncomingCall) return;

      _isShowingIncomingCall = true;

      final navContext = navigatorKey.currentContext;
      if (navContext == null) return;

      Navigator.push(
        navContext,
        MaterialPageRoute(
          builder: (_) => IncomingCallScreen(callData: callData),
        ),
      ).then((_) => _isShowingIncomingCall = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        return user != null ? BottomNavBar() : LoginScreen();
      },
    );
  }
}