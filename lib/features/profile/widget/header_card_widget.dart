import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
import 'package:wio_doctor/features/profile/widget/pill_widget.dart';

class HeaderCardWidget extends StatelessWidget {
  final bool isDark;
  final String fullName;
  final String email;
  final String photoUrl;
  const HeaderCardWidget({
    super.key,
    required this.isDark,
    required this.fullName,
    required this.email,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(isDark),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                Consumer<ProfileViewModel>(
                  builder: (context, profileVM, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Profile image
                        Container(
                          height: 84,
                          width: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.black.withOpacity(0.06),
                            border: Border.all(color: AppColors.border(isDark)),
                          ),
                          child: ClipOval(
                            child:
                                photoUrl.isNotEmpty
                                    ? Image.network(
                                      photoUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Icon(
                                            LucideIcons.userRound,
                                            size: 34,
                                          ),
                                    )
                                    : Icon(LucideIcons.userRound, size: 34),
                          ),
                        ),

                        /// Loader overlay
                        if (profileVM.isUploadingPhoto)
                          Container(
                            height: 84,
                            width: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF14c7eb),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // ✅ plus/pen icon for image update
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () async {
                      await Provider.of<ProfileViewModel>(
                        context,
                        listen: false,
                      ).pickAndUploadProfileImage(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF14c7eb),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.penLine,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isEmpty ? "Doctor Profile" : fullName,
                    style: AppTextStyles.title(18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email.isEmpty ? "Add email address" : email,
                    style: AppTextStyles.body(
                      13,
                    ).copyWith(color: AppColors.subtleText(isDark)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      PillWidget(
                        isDark: isDark,
                        icon: LucideIcons.shieldCheck,
                        text: "Doctor",
                      ),
                      const SizedBox(width: 8),
                      PillWidget(
                        isDark: isDark,
                        icon: LucideIcons.heartPulse,
                        text: "Healthcare",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
