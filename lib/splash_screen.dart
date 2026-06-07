import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freewheel_mart/features/auth/data/auth_screen.dart';
import 'package:freewheel_mart/screens/bottom_navigation.dart';
import 'package:freewheel_mart/screens/home_screen.dart';
import 'package:freewheel_mart/utils/transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _handleSplashGateTrigger() {
    User? user = FirebaseAuth.instance.currentUser;
  
    if (user != null) {
      Navigator.pushReplacement(
        context,
        DiagonalWipePageRoute(page: BottomNavigation()),
      );
    }

    Navigator.pushReplacement(
      context,
      DiagonalWipePageRoute(page: AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 44, 59, 1),
      body: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(36, 44, 59, 1),
          ).animate().fadeIn(duration: 300.ms),

          // 4. Blue diagonal shape sweeps in from bottom-left corner
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipPath(
                clipper: Clip1Clipper(),
                child: Container(
                  height: 185,
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
          ).animate().move(
            begin: const Offset(-500, 500),
            end: Offset.zero,
            duration: 500.ms,
            curve: Curves.easeInOut,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: RotatedBox(
              quarterTurns: 1,
              child:
                  Text(
                        "EXTREME",
                        style: GoogleFonts.allertaStencil(
                          fontSize: 125,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(255, 255, 255, 0.5),
                        ),
                      )
                      .animate()
                      .slideX(
                        begin: 1.0,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      )
                      .blur(begin: const Offset(10, 10), end: Offset.zero),
            ),
          ),

          // 5. Bicycle icon at the top fades + scales in
          Column(
            children: [
              const SizedBox(height: 35),
              Row(
                children: [
                  const Spacer(),
                  Image.asset(
                        "assets/images/logo.png",
                        height: 50,
                        width: 77.63,
                        fit: BoxFit.cover,
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                      ),
                  const Spacer(),
                ],
              ),
            ],
          ),

          // 3. Bicycle image enters from bottom + 7. Continuous floating
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Row(
                children: [
                  const Spacer(),
                  Image.asset(
                        "assets/images/starting.png",
                        height: 400,
                        width: 340,
                        fit: BoxFit.fill,
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .moveY(
                        begin: 0,
                        end: -8,
                        duration: 3.seconds,
                        curve: Curves.easeInOut,
                      )
                      .animate()
                      .moveY(
                        begin: 500,
                        end: 0,
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 800.ms),
                ],
              ),
            ],
          ),

          // 6. "Get Start" button with slide action
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 70,
                    width: 300,
                    child: SlideAction(
                      // LINKED TO THE GATEKEEPER ROUTINE HERE
                      onSubmit: () {
                        _handleSplashGateTrigger();
                        return null;
                      },
                      alignment: Alignment.centerRight,
                      innerColor: const Color.fromRGBO(75, 76, 237, 1),
                      outerColor: const Color.fromRGBO(36, 44, 59, 1),
                      sliderButtonIcon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      text: "Get Started",
                      textStyle: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                      borderRadius: 38,
                      elevation: 4,
                      submittedIcon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().moveY(
                    begin: 100,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Clip1Clipper extends CustomClipper<Path> {
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
