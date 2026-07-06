// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/services/agora_services.dart';
// import 'package:wio_doctor/core/services/time_formate_service.dart';
// import 'package:wio_doctor/core/theme/app_decoration.dart';
// import 'package:wio_doctor/core/theme/app_text_styles.dart';
// import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
// import 'package:wio_doctor/features/appointment/widgets/video_call_screen.dart';
// import 'package:wio_doctor/widgets/avatar_circle_widget.dart';
// import 'package:wio_doctor/widgets/pill_chip_widget.dart';

// class AppointmentCardWidget extends StatelessWidget {
//   final Map<String, dynamic> appointment;
//   final bool isDark;
//   const AppointmentCardWidget({
//     super.key,
//     required this.appointment,
//     required this.isDark,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // ------------------------- STart Video Call Function --------------------------
//     Future<void> startDoctorCall(BuildContext context) async {
//       try {
//         final user = FirebaseAuth.instance.currentUser;
//         if (user == null) return;

//         final doctorId = user.uid;
//         final patientId = appointment["patientId"];

//         if (patientId == null) {
//           Fluttertoast.showToast(
//             msg: "Patient ID missing",
//             backgroundColor: Colors.red,
//           );
//           return;
//         }

//         /// 1️⃣ generate unique channel
//         final channelName = "test_channel";

//         /// 2️⃣ create call signal (doctor → patient)
//         final signal = await AgoraService.createCallSignal(
//           patientId: patientId,
//           doctorId: doctorId,
//           channelName: channelName,
//           patientName: appointment["patientName"],
//           doctorName: appointment["doctorName"],
//           consultationType: appointment["consultationType"],
//           appointmentId: appointment["id"],
//           initiatedBy: "doctor", // ⭐ IMPORTANT --------------
//         );

//         if (signal == null || signal["success"] != true) {
//           throw Exception("Failed to create call signal");
//         }

//         // ← FIX: ID is nested inside "call" object
//         final callData = signal["call"];
//         final signalId = callData?["id"] ?? callData?["sessionId"];

//         // ← ADD THIS to see all keys returned
//         print("📦 Full signal response: $signal");
//         print("📦 Signal keys: ${signal.keys.toList()}");

//         print(
//           " ******Call signal created with ID: $signalId and channel: $channelName",
//         );

//         /// 3️⃣ get Agora token
//         final tokenResponse = await AgoraService.getAgoraToken(
//           channelName: channelName,
//           uid: user.uid,
//           userEmail: user.email ?? "",
//         );

//         if (tokenResponse == null) {
//           throw Exception("Failed to get Agora token");
//         }

//         final agoraToken = tokenResponse["token"];
//         final agoraAccount = tokenResponse["account"]; // ✅ add this

//         if (agoraAccount == null) {
//           throw Exception("Missing Agora account in token response");
//         }

//         /// 4️⃣ navigate to video call
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (_) => VideoCallScreen(
//                   channelName: channelName,
//                   agoraToken: agoraToken,
//                   signalId: signalId,
//                   doctorId: doctorId,
//                   patientId: patientId,
//                   doctorName: appointment["doctorName"] ?? "Doctor",
//                   doctorPhotoURL: appointment["doctorPhotoURL"],
//                   isPatient: false,
//                   userAccount: agoraAccount, // ✅ was user.uid
//                 ),
//           ),
//         );
//       } catch (e) {
//         Navigator.pop(context); // Close any loading dialog if open
//         Fluttertoast.showToast(
//           msg: "Error starting call: $e",
//           backgroundColor: Colors.red,
//         );
//       }
//     }

//     // -----------------------------------------------------------------
//     final status = (appointment["status"] ?? "").toString();
//     final payment = (appointment["payment"] ?? "").toString();
//     final type = (appointment["consultationType"] ?? "").toString();
//     final time = TimeFormateService().getFormattedTime(
//       appointment["slotStart"],
//     );
//     return Container(
//       decoration: AppDecorations.card(isDark),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 AvatarCircleWidget(
//                   name: appointment["patientName"] ?? "Patient",
//                   isDark: isDark,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         appointment["patientName"] ?? "",
//                         style: AppTextStyles.body(
//                           15,
//                         ).copyWith(fontWeight: FontWeight.w900),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         "${appointment["patientWioId"] ?? ""} • ${appointment["slotDate"] ?? ""} • ${time ?? ""}",
//                         style: AppTextStyles.body(12).copyWith(
//                           color:
//                               isDark
//                                   ? Colors.white.withOpacity(0.72)
//                                   : Colors.black.withOpacity(0.65),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 InkWell(
//                   borderRadius: BorderRadius.circular(12),
//                   onTap: () {},
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color:
//                           isDark
//                               ? Colors.white.withOpacity(0.06)
//                               : Colors.black.withOpacity(0.04),
//                       border: Border.all(
//                         color:
//                             isDark
//                                 ? Colors.white.withOpacity(0.08)
//                                 : Colors.black.withOpacity(0.06),
//                       ),
//                     ),
//                     child: Icon(
//                       LucideIcons.chevronRight,
//                       size: 18,
//                       color:
//                           isDark
//                               ? Colors.white.withOpacity(0.85)
//                               : Colors.black.withOpacity(0.75),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 PillChipWidget(
//                   text: type,
//                   icon: LucideIcons.badgeCheck,
//                   statusKey: "confirmed",
//                   isDark: isDark,
//                 ),
//                 PillChipWidget(
//                   text: status,
//                   icon: LucideIcons.clock3,
//                   statusKey: status,
//                   isDark: isDark,
//                 ),
//                 PillChipWidget(
//                   text: payment,
//                   icon: LucideIcons.creditCard,
//                   statusKey: payment,
//                   isDark: isDark,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             status == "pending"
//                 ? Consumer<AppointmentViewModel>(
//                   builder: (context, appointmentVM, child) {
//                     final id = appointment["id"];
//                     final isApprovingThis = appointmentVM.isApproveLoading(id);
//                     final isCancelingThis = appointmentVM.isCancelLoading(id);

//                     return Row(
//                       children: [
//                         Expanded(
//                           child: ShadButton.outline(
//                             width: double.infinity,
//                             decoration: ShadDecoration(
//                               border: ShadBorder.all(
//                                 color: Colors.green,
//                                 radius: BorderRadius.circular(20),
//                               ),
//                             ),
//                             backgroundColor: Colors.green.withOpacity(0.06),
//                             onPressed:
//                                 isApprovingThis
//                                     ? null
//                                     : () async {
//                                       await appointmentVM
//                                           .updateAppointmentStatus(
//                                             context,
//                                             id,
//                                             status: "confirmed",
//                                           );
//                                     },
//                             child:
//                                 isApprovingThis
//                                     ? const SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Colors.green,
//                                             ),
//                                       ),
//                                     )
//                                     : Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(
//                                           LucideIcons.circleCheck,
//                                           size: 15,
//                                           color: Colors.green,
//                                         ),
//                                         const SizedBox(width: 6),
//                                         Text(
//                                           "Confirm Visit",
//                                           style: GoogleFonts.exo(
//                                             fontWeight: FontWeight.w700,
//                                             color: Colors.green,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                           ),
//                         ),
//                         Expanded(
//                           child: ShadButton.outline(
//                             width: double.infinity,
//                             decoration: ShadDecoration(
//                               border: ShadBorder.all(
//                                 color: Colors.red,
//                                 radius: BorderRadius.circular(20),
//                               ),
//                             ),
//                             backgroundColor: Colors.red.withOpacity(0.06),
//                             onPressed: () async {
//                               final controller = TextEditingController();

//                               await showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (_) {
//                                   return Dialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(24),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(22),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Container(
//                                             width: 62,
//                                             height: 62,
//                                             decoration: BoxDecoration(
//                                               color: Colors.red.withOpacity(
//                                                 .12,
//                                               ),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.close_rounded,
//                                               color: Colors.red,
//                                               size: 32,
//                                             ),
//                                           ),

//                                           const SizedBox(height: 18),

//                                           const Text(
//                                             "Cancel Appointment",
//                                             style: TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),

//                                           const SizedBox(height: 8),

//                                           Text(
//                                             "Are you sure you want to cancel this appointment?\nYou may optionally provide a reason.",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               color: Colors.grey.shade600,
//                                               height: 1.5,
//                                             ),
//                                           ),

//                                           const SizedBox(height: 20),

//                                           TextField(
//                                             controller: controller,
//                                             maxLines: 4,
//                                             decoration: InputDecoration(
//                                               hintText:
//                                                   "Cancellation reason (optional)",
//                                               filled: true,
//                                               fillColor: Colors.grey.shade100,
//                                               contentPadding:
//                                                   const EdgeInsets.all(16),
//                                               border: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                                 borderSide: BorderSide.none,
//                                               ),
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                                 borderSide: BorderSide(
//                                                   color: Colors.grey.shade300,
//                                                 ),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                                 borderSide: const BorderSide(
//                                                   color: Colors.red,
//                                                   width: 1.5,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),

//                                           const SizedBox(height: 24),

//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: OutlinedButton(
//                                                   onPressed:
//                                                       () => Navigator.pop(
//                                                         context,
//                                                       ),
//                                                   style: OutlinedButton.styleFrom(
//                                                     minimumSize:
//                                                         const Size.fromHeight(
//                                                           48,
//                                                         ),
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             14,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   child: const Text("Close"),
//                                                 ),
//                                               ),

//                                               const SizedBox(width: 12),

//                                               Expanded(
//                                                 child: ElevatedButton(
//                                                   style: ElevatedButton.styleFrom(
//                                                     backgroundColor: Colors.red,
//                                                     foregroundColor:
//                                                         Colors.white,
//                                                     elevation: 0,
//                                                     minimumSize:
//                                                         const Size.fromHeight(
//                                                           48,
//                                                         ),
//                                                     shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                             14,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                   onPressed: () async {
//                                                     Navigator.pop(context);

//                                                     await appointmentVM
//                                                         .updateAppointmentStatus(
//                                                           context,
//                                                           id,
//                                                           status: "cancelled",
//                                                           remarks:
//                                                               controller.text
//                                                                   .trim(),
//                                                         );
//                                                   },
//                                                   child: const Text(
//                                                     "Cancel Visit",
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   LucideIcons.circleX,
//                                   size: 15,
//                                   color: Colors.red,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   "Cancel Visit",
//                                   style: GoogleFonts.exo(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 )
//                 : status == "cancelled"
//                 ? SizedBox.shrink()
//                 : Row(
//                   children: [
//                     Expanded(
//                       child: ShadButton.outline(
//                         width: double.infinity,
//                         decoration: ShadDecoration(
//                           border: ShadBorder.all(
//                             color: Colors.blue,
//                             radius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         backgroundColor: Colors.blue.withOpacity(0.06),
//                         onPressed: () async {
//                           print("--------- Start Call ----------------");
//                           await startDoctorCall(context);
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               LucideIcons.phone,
//                               size: 15,
//                               color: Colors.blue,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               "Start Call",
//                               style: GoogleFonts.exo(
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: ShadButton.outline(
//                         width: double.infinity,
//                         decoration: ShadDecoration(
//                           border: ShadBorder.all(
//                             color: Colors.green,
//                             radius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         backgroundColor: Colors.green.withOpacity(0.06),
//                         onPressed: () {},
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               LucideIcons.circleCheck,
//                               size: 15,
//                               color: Colors.green,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               "Completed",
//                               style: GoogleFonts.exo(
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ------------------------------- 22222222222222222222222222222 --------------------------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/services/agora_services.dart';
import 'package:wio_doctor/core/services/time_formate_service.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
import 'package:wio_doctor/features/appointment/widgets/video_call_screen.dart';
import 'package:wio_doctor/widgets/avatar_circle_widget.dart';
import 'package:wio_doctor/widgets/pill_chip_widget.dart';

class AppointmentCardWidget extends StatefulWidget {
  // ✅ was StatelessWidget
  final Map<String, dynamic> appointment;
  final bool isDark;
  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.isDark,
  });

  @override
  State<AppointmentCardWidget> createState() => _AppointmentCardWidgetState();
}

class _AppointmentCardWidgetState extends State<AppointmentCardWidget> {
  bool _isCallLoading = false; // ✅ new loading flag

  Future<void> _startDoctorCall(BuildContext context) async {
    if (_isCallLoading) return; // ✅ guard against double taps
    setState(() => _isCallLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doctorId = user.uid;
      final patientId = widget.appointment["patientId"];

      if (patientId == null) {
        Fluttertoast.showToast(
          msg: "Patient ID missing",
          backgroundColor: Colors.red,
        );
        return;
      }

      /// 1️⃣ generate unique channel
      final channelName = "test_channel";

      /// 2️⃣ create call signal (doctor → patient)
      final signal = await AgoraService.createCallSignal(
        patientId: patientId,
        doctorId: doctorId,
        channelName: channelName,
        patientName: widget.appointment["patientName"],
        doctorName: widget.appointment["doctorName"],
        consultationType: widget.appointment["consultationType"],
        appointmentId: widget.appointment["id"],
        initiatedBy: "doctor",
      );

      if (signal == null || signal["success"] != true) {
        throw Exception("Failed to create call signal");
      }

      final callData = signal["call"];
      final signalId = callData?["id"] ?? callData?["sessionId"];

      print("📦 Full signal response: $signal");
      print("📦 Signal keys: ${signal.keys.toList()}");
      print(
        " ******Call signal created with ID: $signalId and channel: $channelName",
      );

      /// 3️⃣ get Agora token
      final tokenResponse = await AgoraService.getAgoraToken(
        channelName: channelName,
        uid: user.uid,
        userEmail: user.email ?? "",
      );

      if (tokenResponse == null) {
        throw Exception("Failed to get Agora token");
      }

      final agoraToken = tokenResponse["token"];
      final agoraAccount = tokenResponse["account"];

      if (agoraAccount == null) {
        throw Exception("Missing Agora account in token response");
      }

      if (!mounted) return; // ✅ safe after awaits

      /// 4️⃣ navigate to video call
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => VideoCallScreen(
                channelName: channelName,
                agoraToken: agoraToken,
                signalId: signalId,
                doctorId: doctorId,
                patientId: patientId,
                doctorName: widget.appointment["doctorName"] ?? "Doctor",
                doctorPhotoURL: widget.appointment["doctorPhotoURL"],
                isPatient: false,
                userAccount: agoraAccount,
              ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error starting call: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isCallLoading = false); // ✅ always reset
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment =
        widget.appointment; // ✅ keep old variable name for minimal diff below
    final isDark = widget.isDark;

    final status = (appointment["status"] ?? "").toString();
    final payment = (appointment["payment"] ?? "").toString();
    final type = (appointment["consultationType"] ?? "").toString();
    final time = TimeFormateService().getFormattedTime(
      appointment["slotStart"],
    );
    return Container(
      decoration: AppDecorations.card(isDark),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                AvatarCircleWidget(
                  name: appointment["patientName"] ?? "Patient",
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment["patientName"] ?? "",
                        style: AppTextStyles.body(
                          15,
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${appointment["patientWioId"] ?? ""} • ${appointment["slotDate"] ?? ""} • ${time ?? ""}",
                        style: AppTextStyles.body(12).copyWith(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.72)
                                  : Colors.black.withOpacity(0.65),
                        ),
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
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                      ),
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
                PillChipWidget(
                  text: type,
                  icon: LucideIcons.badgeCheck,
                  statusKey: "confirmed",
                  isDark: isDark,
                ),
                PillChipWidget(
                  text: status,
                  icon: LucideIcons.clock3,
                  statusKey: status,
                  isDark: isDark,
                ),
                PillChipWidget(
                  text: payment,
                  icon: LucideIcons.creditCard,
                  statusKey: payment,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 12),
            status == "pending"
                ? Consumer<AppointmentViewModel>(
                  builder: (context, appointmentVM, child) {
                    final id = appointment["id"];
                    final isApprovingThis = appointmentVM.isApproveLoading(id);
                    final isCancelingThis = appointmentVM.isCancelLoading(id);

                    return Row(
                      children: [
                        Expanded(
                          child: ShadButton.outline(
                            width: double.infinity,
                            decoration: ShadDecoration(
                              border: ShadBorder.all(
                                color: Colors.green,
                                radius: BorderRadius.circular(20),
                              ),
                            ),
                            backgroundColor: Colors.green.withOpacity(0.06),
                            onPressed:
                                isApprovingThis
                                    ? null
                                    : () async {
                                      await appointmentVM
                                          .updateAppointmentStatus(
                                            context,
                                            id,
                                            status: "confirmed",
                                          );
                                    },
                            child:
                                isApprovingThis
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.green,
                                            ),
                                      ),
                                    )
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          LucideIcons.circleCheck,
                                          size: 15,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Confirm Visit",
                                          style: GoogleFonts.exo(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                        Expanded(
                          child: ShadButton.outline(
                            width: double.infinity,
                            decoration: ShadDecoration(
                              border: ShadBorder.all(
                                color: Colors.red,
                                radius: BorderRadius.circular(20),
                              ),
                            ),
                            backgroundColor: Colors.red.withOpacity(0.06),
                            onPressed: () async {
                              final controller = TextEditingController();

                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 62,
                                            height: 62,
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(
                                                .12,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.red,
                                              size: 32,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          const Text(
                                            "Cancel Appointment",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Are you sure you want to cancel this appointment?\nYou may optionally provide a reason.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              height: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: controller,
                                            maxLines: 4,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Cancellation reason (optional)",
                                              filled: true,
                                              fillColor: Colors.grey.shade100,
                                              contentPadding:
                                                  const EdgeInsets.all(16),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  style: OutlinedButton.styleFrom(
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                          48,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text("Close"),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                          48,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await appointmentVM
                                                        .updateAppointmentStatus(
                                                          context,
                                                          id,
                                                          status: "cancelled",
                                                          remarks:
                                                              controller.text
                                                                  .trim(),
                                                        );
                                                  },
                                                  child: const Text(
                                                    "Cancel Visit",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.circleX,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Cancel Visit",
                                  style: GoogleFonts.exo(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
                : status == "cancelled"
                ? SizedBox.shrink()
                : Row(
                  children: [
                    Expanded(
                      child: ShadButton.outline(
                        width: double.infinity,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(
                            color: Colors.blue,
                            radius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.blue.withOpacity(0.06),
                        // ✅ disable while loading
                        onPressed:
                            _isCallLoading
                                ? null
                                : () async {
                                  print(
                                    "--------- Start Call ----------------",
                                  );
                                  await _startDoctorCall(context);
                                },
                        // ✅ swap in a spinner while loading
                        child:
                            _isCallLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.phone,
                                      size: 15,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Start Call",
                                      style: GoogleFonts.exo(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShadButton.outline(
                        width: double.infinity,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(
                            color: Colors.green,
                            radius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.green.withOpacity(0.06),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.circleCheck,
                              size: 15,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Completed",
                              style: GoogleFonts.exo(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
