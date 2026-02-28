import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/widgets/header_row_widget.dart';

class WioCaseDiscussionScreen extends StatefulWidget {
  const WioCaseDiscussionScreen({super.key});

  @override
  State<WioCaseDiscussionScreen> createState() =>
      _WioCaseDiscussionScreenState();
}

class _WioCaseDiscussionScreenState extends State<WioCaseDiscussionScreen> {
  final caseTitleC = TextEditingController();
  final caseSummaryC = TextEditingController();
  final questionC = TextEditingController();

  String responseType = "Short Notes";

  /// Dummy image list (replace with image picker later)
  final List<String> attachedImages = [];

  @override
  void dispose() {
    caseTitleC.dispose();
    caseSummaryC.dispose();
    questionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          child: Column(
            children: [
              /// ================= CASE DETAILS CARD =================
              Container(
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
                    const SizedBox(height: 6),
                    _textField(
                      controller: caseTitleC,
                      hint: "Enter case title",
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    /// Case Summary
                    _label("Detailed Case Summary"),
                    const SizedBox(height: 6),
                    _textField(
                      controller: caseSummaryC,
                      hint:
                          "Include patient history, key findings, and specific clinical question...",
                      maxLines: 6,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 18),

                    /// Attach Images
                    _label("Attach Images"),
                    const SizedBox(height: 8),
                    _imageAttachSection(isDark),

                    const SizedBox(height: 18),

                    /// Response Type Dropdown
                    _label("Response Type"),
                    const SizedBox(height: 6),

                    ShadSelect<String>(
                      initialValue: responseType,
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
                      selectedOptionBuilder: (context, value) => Text(value),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => responseType = value);
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    /// Comment / Question
                    _label("Ask a Question or Add Comment"),
                    const SizedBox(height: 6),
                    _textField(
                      controller: questionC,
                      hint: "Type your question or comment...",
                      maxLines: 3,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),

                    /// Send Button
                    ShadButton(
                      width: double.infinity,
                      backgroundColor: Colors.teal,
                      pressedBackgroundColor: Colors.teal,
                      onPressed: _submitCase,
                      child: Text(
                        "Send Case",
                        style: AppTextStyles.section(
                          16,
                        ).copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= LABEL =================
  Widget _label(String text) {
    return Text(text, style: AppTextStyles.section(14));
  }

  /// ================= TEXT FIELD =================
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border(isDark)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.border(isDark)),
        ),
      ),
    );
  }

  /// ================= IMAGE ATTACH SECTION =================
  Widget _imageAttachSection(bool isDark) {
    return Column(
      children: [
        if (attachedImages.isEmpty)
          InkWell(
            onTap: () {
              // TODO: open image picker
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border(isDark)),
              ),
              child: Column(
                children: [
                  Icon(LucideIcons.imagePlus, color: Colors.teal),
                  const SizedBox(height: 6),
                  Text("Tap to attach images", style: AppTextStyles.body(13)),
                ],
              ),
            ),
          ),

        if (attachedImages.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                attachedImages.map((img) {
                  return Stack(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Icon(Icons.close, size: 18),
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
      ],
    );
  }

  /// ================= SUBMIT =================
  void _submitCase() {
    print("Case Title: ${caseTitleC.text}");
    print("Summary: ${caseSummaryC.text}");
    print("Question: ${questionC.text}");
    print("Response Type: $responseType");
  }
}
