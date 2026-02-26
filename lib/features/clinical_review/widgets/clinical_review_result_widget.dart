import 'package:flutter/material.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/widgets/header_row_widget.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ClinicalReviewResultWidget extends StatelessWidget {
  final Map? data;

  const ClinicalReviewResultWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (data == null) {
      return _emptyCard(isDark, "No clinical review available");
    }

    final synthesis = data?["synthesis"] ?? "No synthesis available";
    final List oversights = data?["potentialOversights"] ?? [];
    final List terms = data?["elaboratedTerms"] ?? [];
    final List references = data?["academicReferences"] ?? [];

    return Container(
      decoration: AppDecorations.card(isDark),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= SYNTHESIS =================
          HeaderRowWidget(
            icon: LucideIcons.brain,
            title: "Clinical Synthesis",
            subTitle: "AI generated summary of clinical findings",
          ),

          const SizedBox(height: 12),

          _infoBox(isDark, synthesis.toString()),

          const SizedBox(height: 20),

          /// ================= OVERSIGHTS =================
          HeaderRowWidget(
            icon: LucideIcons.circleAlert,
            title: "Potential Oversights",
            subTitle: "Possible missing context or risks",
          ),

          const SizedBox(height: 12),

          if (oversights.isEmpty)
            _emptyCard(isDark, "No potential oversights detected"),

          if (oversights.isNotEmpty)
            ...oversights.map((o) {
              return _oversightItem(
                isDark,
                o["finding"] ?? "",
                o["implication"] ?? "",
              );
            }),

          /// ================= ELABORATED TERMS =================
          const SizedBox(height: 20),

          HeaderRowWidget(
            icon: LucideIcons.bookOpen,
            title: "Medical Terms Explained",
            subTitle: "Detailed explanation of clinical terms",
          ),

          const SizedBox(height: 12),

          if (terms.isEmpty) _emptyCard(isDark, "No medical terms available"),

          if (terms.isNotEmpty)
            ...terms.map((t) {
              return _termItem(isDark, t["term"] ?? "", t["explanation"] ?? "");
            }),

          /// ================= ACADEMIC REFERENCES =================
          const SizedBox(height: 20),

          HeaderRowWidget(
            icon: LucideIcons.graduationCap,
            title: "Academic References",
            subTitle: "Related medical research topics",
          ),

          const SizedBox(height: 12),

          if (references.isEmpty)
            _emptyCard(isDark, "No academic references available"),

          if (references.isNotEmpty)
            ...references.map((r) {
              return _referenceItem(
                isDark,
                r["topic"] ?? "",
                r["reasoning"] ?? "",
                r["pubmedQuery"] ?? "",
              );
            }),
        ],
      ),
    );
  }

  /// ================= INFO BOX =================
  Widget _infoBox(bool isDark, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Text(text, style: AppTextStyles.body(13.5)),
    );
  }

  /// ================= OVERSIGHT ITEM =================
  Widget _oversightItem(bool isDark, String finding, String implication) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withOpacity(0.05) : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? Colors.red.withOpacity(0.3)
                  : Colors.red.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Finding", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          Text(finding, style: AppTextStyles.body(13)),
          const SizedBox(height: 10),
          Text("Implication", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          Text(implication, style: AppTextStyles.body(13)),
        ],
      ),
    );
  }

  Widget _termItem(bool isDark, String term, String explanation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.withOpacity(0.05) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.blue.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Term", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          Text(term, style: AppTextStyles.body(13)),

          const SizedBox(height: 10),

          Text("Explanation", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          Text(explanation, style: AppTextStyles.body(13)),
        ],
      ),
    );
  }

  Widget _referenceItem(
    bool isDark,
    String topic,
    String reasoning,
    String query,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.green.withOpacity(0.05) : Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? Colors.green.withOpacity(0.3)
                  : Colors.green.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Topic", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          Text(topic, style: AppTextStyles.body(13)),

          const SizedBox(height: 10),

          Text("Reasoning", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          Text(reasoning, style: AppTextStyles.body(13)),

          const SizedBox(height: 10),

          Text("PubMed Query", style: AppTextStyles.section(13)),
          const SizedBox(height: 4),
          SelectableText(query, style: AppTextStyles.body(12)),
        ],
      ),
    );
  }

  /// ================= EMPTY =================
  Widget _emptyCard(bool isDark, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Text(
        text,
        style: AppTextStyles.body(
          13,
        ).copyWith(color: AppColors.subtleText(isDark)),
      ),
    );
  }
}
