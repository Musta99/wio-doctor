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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
import 'package:wio_doctor/features/auth/view/login_screen.dart';

import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';
import 'package:wio_doctor/features/auth/view_model/signup_viewmodel.dart';
import 'package:wio_doctor/features/bottom_nav_bar/view/bottom_nav_bar.dart';
import 'package:wio_doctor/features/clinical_review/view_model/clinical_review_view_model.dart';
import 'package:wio_doctor/features/consultation_fee/view_model/consultation_fee_view_model.dart';
import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:wio_doctor/features/digital_prescription/view_model/digital_prescription_view_model.dart';
import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';
import 'package:wio_doctor/features/patient_access/view_model/patient_access_view_model.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';
import 'package:wio_doctor/features/wio_case_discussion/view_model/case_discussion_view_model.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';
import 'package:wio_doctor/view_model/date_picker_view_model.dart';

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
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider()..init(),
        ),
        ChangeNotifierProvider(create: (context) => SignupViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewmodel()),
        ChangeNotifierProvider(create: (context) => DashboardViewModel()),
        ChangeNotifierProvider(create: (context) => PatientViewModel()),
        ChangeNotifierProvider(create: (context) => DatePickerProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleViewModel()),
        ChangeNotifierProvider(create: (context) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ConsultationFeeViewModel()),
        ChangeNotifierProvider(
          create: (context) => DigitalPrescriptionViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => ClinicalReviewViewModel()),
        ChangeNotifierProvider(create: (context) => CaseDiscussionViewModel()),
        ChangeNotifierProvider(create: (context) => PatientAccessViewModel()),
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
          home:
              FirebaseAuth.instance.currentUser != null
                  ? BottomNavBar()
                  : LoginScreen(),
        );
      },
    );
  }
}
