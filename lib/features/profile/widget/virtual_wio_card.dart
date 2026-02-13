import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VirtualWioCard extends StatefulWidget {
  final String? wioId;
  final String? uid; // Placeholder UID
  final String? name;
  final String? bloodType;
  final String? address;
  final String cardType; // "patient" or "doctor"

  const VirtualWioCard({
    Key? key,
    this.wioId,
    this.uid,
    this.name,
    this.bloodType,
    this.address,
    this.cardType = "patient",
  }) : super(key: key);

  @override
  State<VirtualWioCard> createState() => _VirtualWioCardState();
}

class _VirtualWioCardState extends State<VirtualWioCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  // bool _isFlipped = false;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final langaugeVM = Provider.of<LanguageViewModel>(context);

    final displayId = widget.wioId ?? widget.uid ?? 'N/A';
    final name = widget.name ?? 'N/A';
    final bloodGroup = widget.bloodType ?? 'N/A';
    final address =
        widget.address ??
        (widget.cardType == "doctor"
            ? "No clinic address provided"
            : "No address provided");

    return Container(
      constraints: const BoxConstraints(maxWidth: 448),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final angle = _flipAnimation.value * 3.14159; // π radians
              final isFrontVisible = angle < 1.5708; // π/2

              return Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                child:
                    isFrontVisible
                        ? _buildFrontCard(displayId, name)
                        : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.14159),
                          child: _buildBackCard(displayId, bloodGroup, address),
                        ),
              );
            },
          ),
          SizedBox(height: 6),

          // Buttons at bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // if (profileVM.isCardFlipped) {
                  //   _flipController.reverse();
                  // } else {
                  //   _flipController.forward();
                  // }
                  // profileVM.toggleCardFlip();
                },
                icon: Icon(LucideIcons.rotateCcw, size: 16),
                label: Text('Flip Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: widget.wioId!));

                  // Fluttertoast.showToast(
                  //   msg: "Copied to clipboard",
                  //   backgroundColor: Colors.green,
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                ),
                child: Text(_copied ? 'Copied!' : 'Copy WIO-ID'),
              ),
            ],
          ),
          SizedBox(height: 5),

          // Download Button
          ShadButton(
            width: MediaQuery.of(context).size.width,
            backgroundColor: Color(0xFF14c7eb),
            pressedBackgroundColor: Color(0xFF14c7eb),
            onPressed: () async {
              try {
                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (BuildContext dialogContext) =>
                          const Center(child: CircularProgressIndicator()),
                );

                // await CardPdfGenerator.downloadCard(
                //   displayId: widget.wioId ?? widget.uid ?? 'N/A',
                //   name: widget.name ?? 'N/A',
                //   bloodGroup: widget.bloodType ?? 'N/A',
                //   address:
                //       widget.address ??
                //       (widget.cardType == "doctor"
                //           ? "No clinic address provided"
                //           : "No address provided"),
                //   cardType: widget.cardType,
                // );

                // Close loading dialog
                Navigator.of(context).pop();

                // Show success toast using ShadToaster
                ShadToaster.of(context).show(
                  ShadToast(
                    description: Text(
                      // langaugeVM.translate(
                      //   'Card downloaded successfully!',
                      //   'কার্ডটি সফলভাবে ডাউনলোড হয়েছে!',
                      // ),
                      "Card downloaded successfully!",
                    ),
                  ),
                );
              } catch (e) {
                // Close loading dialog
                Navigator.of(context).pop();

                // Show error toast
                ShadToaster.of(
                  context,
                ).show(ShadToast(description: Text('Error: $e')));
              }
            },

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.download, size: 16),
                SizedBox(width: 8),
                Text("Download"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(String displayId, String name) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14B8A6), // teal-500
            Color(0xFF0891B2), // cyan-600
            Color(0xFF0F766E), // teal-700
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Radial gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: RadialGradient(
                center: const Alignment(0.7, -0.7),
                radius: 1.5,
                colors: [Colors.white.withOpacity(0.12), Colors.transparent],
              ),
            ),
          ),
          // Additional gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF14B8A6).withOpacity(0.6),
                  const Color(0xFF0891B2).withOpacity(0.7),
                  const Color(0xFF0F766E).withOpacity(0.8),
                ],
              ),
            ),
          ),
          // Logo Watermark
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/icons/wio_logo.png', // Replace with your logo path
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'VIRTUAL WIO CARD',
                      style: GoogleFonts.exo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNIFIED MEMBER ID',
                      style: GoogleFonts.exo(
                        color: const Color(0xFF99F6E4), // teal-100
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),

                    Text(
                      displayId,
                      style: GoogleFonts.exo(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.8,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ID and Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARDHOLDER',
                      style: TextStyle(
                        color: const Color(0xFF99F6E4), // teal-100
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      name.toUpperCase(),
                      style: GoogleFonts.exo(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Shine overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(String displayId, String bloodGroup, String address) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14B8A6), // teal-500
            Color(0xFF0891B2), // cyan-600
            Color(0xFF0F766E), // teal-700
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Radial gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: RadialGradient(
                center: const Alignment(0.7, -0.7),
                radius: 1.5,
                colors: [Colors.white.withOpacity(0.12), Colors.transparent],
              ),
            ),
          ),
          // Additional gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF14B8A6).withOpacity(0.6),
                  const Color(0xFF0891B2).withOpacity(0.7),
                  const Color(0xFF0F766E).withOpacity(0.8),
                ],
              ),
            ),
          ),
          // Logo Watermark
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/icons/wio_logo.png', // Replace with your logo path
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blood Group and Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cardType == "doctor"
                            ? 'SPECIALTY'
                            : 'BLOOD GROUP',
                        style: GoogleFonts.exo(
                          color: const Color(0xFF99F6E4), // teal-100
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bloodGroup.toUpperCase(),
                        style: GoogleFonts.exo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.cardType == "doctor"
                            ? 'CLINIC ADDRESS'
                            : 'ADDRESS',
                        style: GoogleFonts.exo(
                          color: const Color(0xFF99F6E4), // teal-100
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        address,
                        style: GoogleFonts.exo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                // QR Code
                Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: PrettyQrView.data(
                    data: displayId,
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Shine overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
