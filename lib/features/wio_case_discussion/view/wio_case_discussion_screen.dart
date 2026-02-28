import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/features/wio_case_discussion/view_model/case_discussion_view_model.dart';
import 'package:wio_doctor/widgets/header_row_widget.dart';

class WioCaseDiscussionScreen extends StatelessWidget {
  const WioCaseDiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<CaseDiscussionViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Case Details", style: AppTextStyles.title(18)),
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Container(
                decoration: AppDecorations.card(isDark),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRowWidget(
                      icon: LucideIcons.stethoscope,
                      title: "Case Details",
                      subTitle:
                          "Provide case summary, patient history, findings, and question",
                    ),

                    const SizedBox(height: 18),

                    /// Case Title
                    _label("Case Title"),
                    _textField(
                      controller: vm.caseTitleC,
                      hint: "Enter case title",
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    /// Summary
                    _label("Detailed Case Summary"),
                    _textField(
                      controller: vm.caseSummaryC,
                      hint: "Include patient history, key findings...",
                      isDark: isDark,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 18),

                    /// Image
                    _label("Attach Image"),
                    _imageAttachSection(vm, isDark),

                    const SizedBox(height: 18),

                    /// Response Type
                    _label("Response Type"),
                    ShadSelect<String>(
                      initialValue:
                          vm.responseType == "concise"
                              ? "Short Notes"
                              : "Elaborate",
                      options: const [
                        ShadOption(
                          value: "Short Notes",
                          child: Text("Short Notes"),
                        ),
                        ShadOption(
                          value: "Elaborate",
                          child: Text("Elaborate"),
                        ),
                      ],
                      selectedOptionBuilder: (_, v) => Text(v),
                      onChanged: (v) => vm.setResponseType(v!),
                    ),

                    const SizedBox(height: 18),

                    /// Question
                    _label("Ask Question"),
                    _textField(
                      controller: vm.questionC,
                      hint: "Type your question...",
                      isDark: isDark,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),

                    /// ============ Submit Button ============
                    ShadButton(
                      width: double.infinity,
                      backgroundColor: Colors.teal,
                      onPressed:
                          vm.isLoadingCaseDiscussion
                              ? null
                              : () => vm.initiateCaseDiscussion(context),
                      child:
                          vm.isLoadingCaseDiscussion
                              ? Icon(LucideIcons.loader, size: 22)
                              : Text(
                                "Send Case",
                                style: AppTextStyles.section(
                                  16,
                                ).copyWith(color: Colors.white),
                              ),
                    ),

                    // --------------------------------
                    _discussionResult(vm, isDark),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppTextStyles.section(14)),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: AppDecorations.inputDec(hint, LucideIcons.pencil, isDark),
    );
  }

  Widget _imageAttachSection(CaseDiscussionViewModel vm, bool isDark) {
    if (vm.selectedImage == null) {
      return InkWell(
        onTap: vm.pickImage,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(isDark),
          child: Column(
            children: [
              Icon(LucideIcons.imagePlus, color: Colors.teal),
              const SizedBox(height: 6),
              Text("Tap to attach image", style: AppTextStyles.body(13)),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(vm.selectedImage!, height: 120),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: vm.removeImage,
            child: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  /// ================= DISCUSSION RESULT =================
  Widget _discussionResult(CaseDiscussionViewModel vm, bool isDark) {
    if (vm.isLoadingCaseDiscussion) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(color: Colors.teal,)),
      );
    }

    if (vm.discussionList.isEmpty) {
      return const SizedBox(); // hide initially
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),

        Text("AI Case Discussion", style: AppTextStyles.section(16)),

        const SizedBox(height: 12),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.discussionList.length,
          itemBuilder: (context, index) {
            final item = vm.discussionList[index];

            final persona = item["persona"] ?? "Doctor";
            final comment = item["comment"] ?? "";

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: AppDecorations.card(isDark),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Persona
                  Row(
                    children: [
                      const Icon(Icons.psychology, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        persona,
                        style: AppTextStyles.section(
                          14,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Comment
                  Text(comment, style: AppTextStyles.body(13)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
