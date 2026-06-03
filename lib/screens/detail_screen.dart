import 'package:flutter/material.dart';
import 'package:freewheel_mart/screens/shoping_page.dart';
import 'package:freewheel_mart/utils/transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailScreen({super.key, required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  bool _isDescriptionSelected = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 44, 59, 1),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipPath(
                clipper: Clip3Clipper(),
                child: Container(
                  height: 135,
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
          ),
          // 2. The "EXTREME" watermark fades in slowly
          Align(
            alignment: Alignment.centerRight,
            child: RotatedBox(
              quarterTurns: 1,
              child: Text(
                "EXTREME",
                style: GoogleFonts.allertaStencil(
                  fontSize: 125,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ).animate().fadeIn(duration: 1.seconds),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Text(
                      widget.data["name"],
                      style: GoogleFonts.poppins(
                        fontSize: 27,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    const Spacer(),
                    // 9. Back arrow button rotates on tap
                    GestureDetector(
                      onTap: () async {
                        // Small delay to show rotation before popping
                        await Future.delayed(200.ms);
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                      child:
                          Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(55, 182, 233, 1),
                                      Color.fromRGBO(72, 92, 236, 1),
                                      Color.fromRGBO(75, 76, 237, 1),
                                    ],
                                    end: Alignment.bottomRight,
                                    begin: Alignment.topLeft,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 30,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              )
                              .animate(onPlay: (c) => c.stop())
                              .rotate(duration: 360.ms),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    // 1. Bicycle image slides in from right with rotation
                    SizedBox(
                      height: 360,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          if (page == 3) {
                            _pageController.jumpToPage(0);
                          } else {
                            setState(() {
                              _currentPage = page;
                            });
                          }
                        },
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.asset(
                            widget.data["image"],
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                    // 3. Image carousel dots animate in with fade
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(3, (int index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          height: 10.0,
                          width: _currentPage == index ? 10.0 : 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? const Color.fromRGBO(0, 0, 0, 1)
                                : const Color.fromRGBO(217, 217, 217, 1),
                          ),
                        );
                      }),
                    ).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 10),
                    // 4. Tab bar slides up
                    Container(
                      width: double.infinity,
                      height: 400,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border.all(
                          width: 2,
                          color: const Color.fromRGBO(255, 251, 251, 0.2),
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(53, 63, 84, 0.8),
                            Color.fromRGBO(34, 40, 52, 0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isDescriptionSelected = true;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(
                                        255,
                                        251,
                                        251,
                                        0.5,
                                      ),
                                    ),
                                    color: _isDescriptionSelected
                                        ? const Color.fromRGBO(36, 44, 59, 1)
                                        : const Color.fromRGBO(72, 92, 236, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${widget.data["name"]} Description",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isDescriptionSelected = false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color.fromRGBO(
                                        255,
                                        251,
                                        251,
                                        0.5,
                                      ),
                                    ),
                                    color: _isDescriptionSelected
                                        ? const Color.fromRGBO(72, 92, 236, 1)
                                        : const Color.fromRGBO(36, 44, 59, 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${widget.data["name"]} Specification",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // 5. Description/Specification text fades in staggered
                          SizedBox(
                            height: 180, // Fixed height to maintain box size
                            child: SingleChildScrollView(
                              child:
                                  Text(
                                        _isDescriptionSelected
                                            ? "${widget.data["description"]}"
                                            : "${widget.data["specification"]}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1,
                                          ),
                                        ),
                                      )
                                      .animate(
                                        key: ValueKey(_isDescriptionSelected),
                                      )
                                      .fadeIn(duration: 500.ms),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ).animate().moveY(
                      begin: 100,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(36, 44, 59, 1),
        height: 70,
        child: Row(
          children: [
            const SizedBox(width: 5),
            // 6. Price counts up
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: (widget.data["price"] as num).toDouble(),
              ),
              duration: 600.ms,
              builder: (context, value, child) {
                return Text(
                  "\$${value.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                );
              },
            ),
            const Spacer(),
            // 7. "Buy Now" button slides up + glow pulse
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  DiagonalWipePageRoute(page: const MyShopping()),
                );
              },
              child:
                  Container(
                        height: 45,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(255, 251, 251, 0),
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(55, 182, 233, 1),
                              Color.fromRGBO(75, 76, 237, 1),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 5),
                              blurRadius: 5,
                              spreadRadius: 0,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Buy Now",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .moveY(
                        begin: 50,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOut,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(
                        delay: 1.seconds,
                        duration: 2.seconds,
                        color: Colors.white24,
                      ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

class Clip3Clipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
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
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
