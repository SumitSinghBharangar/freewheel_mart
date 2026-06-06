import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 44, 59, 1),
      body: Stack(
        children: [
          // 1. Diagonal wipe / Curtain effect for blue bottom half
          Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipPath(
                    clipper: Clip4Clipper(),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color.fromRGBO(75, 76, 237, 1),
                    ),
                  ),
                  Container(
                    height: 330,
                    width: double.infinity,
                    color: const Color.fromRGBO(75, 76, 237, 1),
                  ),
                ],
              )
              .animate()
              .move(
                begin: const Offset(0, 500),
                end: Offset.zero,
                duration: 600.ms,
                curve: Curves.easeOut,
              )
              .shimmer(duration: 2.seconds, color: Colors.white10),

          // 2. "EXTREME" watermark text fades in softly
          Align(
            alignment: Alignment.centerRight,
            child: RotatedBox(
              quarterTurns: 1,
              child: Text(
                "FREEWHEEL",
                style: GoogleFonts.allertaStencil(
                  fontSize: 125,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(255, 255, 255, 0.15),
                ),
              ).animate().fadeIn(duration: 800.ms),
            ),
          ),

          // 4. Small animated bicycle icon tracing a path (simplified as a moving icon)
          Positioned(
            bottom: 330,
            left: 0,
            child:
                const Icon(
                      Icons.directions_bike,
                      color: Colors.white24,
                      size: 30,
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .moveX(
                      begin: -50,
                      end: 500,
                      duration: 3.seconds,
                      curve: Curves.linear,
                    ),
          ),
        ],
      ),
    );
  }
}

class Clip4Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Move to the top-right corner
    path.moveTo(size.width, 0);
    // Draw a line to the bottom-right corner
    path.lineTo(size.width, size.height);
    // Draw a line to the bottom-left corner
    path.lineTo(0, size.height);
    // Close the path to form the triangle
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
