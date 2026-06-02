import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MyShopping extends StatefulWidget {
  const MyShopping({super.key});

  @override
  State<MyShopping> createState() => _MyShoppingState();
}

class _MyShoppingState extends State<MyShopping> {
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
                clipper: Clip4Clipper(),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: const Color.fromRGBO(30, 30, 30, 1),
                ),
              ),
              Container(
                height: 330,
                width: double.infinity,
                color: const Color.fromRGBO(30, 30, 30, 1),
              ),
            ],
          ),
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
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // 1. Page enter: "My Shopping Cart" header fades + slides down
                const SizedBox(height: 40),
                Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 30,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Text(
                            "My Shopping Cart",
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
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
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: -0.5, end: 0),
                const SizedBox(height: 20),
                // 2. Each cart item slides in from right with stagger
                _buildCartItem(
                  "assets/bicycle3.png",
                  "GT Bike",
                  2599.99,
                  delay: 100.ms,
                ),
                _buildCartItem(
                  "assets/helmet.png",
                  "Helmet",
                  125.99,
                  delay: 200.ms,
                ),
                _buildCartItem(
                  "assets/bottle.png",
                  "Bottle",
                  115.99,
                  delay: 300.ms,
                ),

                // 5. "Your Bag Qualifies for Free Shipping" text highlight pulse
                Text(
                      "Your Bag Qualifies for Free Shipping",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    )
                    .animate(delay: 1.seconds)
                    .tint(color: Colors.blueAccent, duration: 500.ms)
                    .then()
                    .tint(color: Colors.transparent),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      // 6. Coupon input field pulse
                      Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(36, 44, 50, 0.6),
                              border: Border.all(
                                width: 2,
                                color: const Color.fromRGBO(0, 0, 0, 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "6Affg5",
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        142,
                                        142,
                                        142,
                                        1,
                                      ),
                                    ),
                                  ),
                                ),
                                // 7. "Apply" button ripple
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 42,
                                    width: 130,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(55, 182, 233, 1),
                                          Color.fromRGBO(72, 92, 236, 1),
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      "Apply",
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
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
                              ],
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .shimmer(
                            duration: 3.seconds,
                            color: Colors.blue.withValues(alpha: 0.1),
                          ),
                      const SizedBox(height: 15),
                      // 8. Summary rows count up staggered
                      _buildSummaryRow("Subtotal", 2841.99, delay: 0.ms),
                      _buildSummaryRow("Delivery fee", 0, delay: 80.ms),
                      _buildSummaryRow(
                        "Discount",
                        30,
                        isPercent: true,
                        delay: 160.ms,
                      ),
                      // 9. "Total" row bold scale-up pop
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: _buildSummaryRow(
                          "Total",
                          1989.37,
                          isTotal: true,
                          delay: 240.ms,
                        ),
                      ),

                      const SizedBox(height: 10),
                      // 10. "Check Out" button slide up + shimmer
                      GestureDetector(
                        onTap: () {},
                        child:
                            Container(
                                  height: 50,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(55, 182, 233, 1),
                                        Color.fromRGBO(72, 92, 236, 1),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Check Out",
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .moveY(
                                  begin: 50,
                                  end: 0,
                                  duration: 600.ms,
                                  curve: Curves.easeOut,
                                )
                                .animate(onPlay: (c) => c.repeat())
                                .shimmer(
                                  delay: 3.seconds,
                                  duration: 2.seconds,
                                  color: Colors.white24,
                                ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    String imagePath,
    String name,
    double price, {
    required Duration delay,
  }) {
    return Column(
      children:
          [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    // 3. Item images subtle scale-in
                    Container(
                      width: 125,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: Colors.white30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(53, 63, 84, 0.6),
                            Color.fromRGBO(34, 40, 52, 0),
                          ],
                        ),
                      ),
                      child: Image.asset(imagePath, fit: BoxFit.cover)
                          .animate()
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                            duration: 400.ms,
                          ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "\$${price.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(55, 182, 233, 1),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                    const Spacer(),
                    // 4. +/- buttons spring bounce
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 31,
                          width: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.black45,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.add,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.stop())
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.1, 1.1),
                                    duration: 150.ms,
                                    curve: Curves.bounceOut,
                                  ),
                              Text(
                                "1",
                                style: GoogleFonts.allertaStencil(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.stop())
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.1, 1.1),
                                    duration: 150.ms,
                                    curve: Curves.bounceOut,
                                  ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(height: 2, color: Colors.white70),
            ),
          ].animate().slideX(
            begin: 1.0,
            end: 0,
            delay: delay,
            duration: 600.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    bool isPercent = false,
    bool isTotal = false,
    required Duration delay,
  }) {
    Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: Colors.white,
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value),
            duration: 600.ms,
            builder: (context, val, child) {
              return Text(
                isPercent ? "${val.toInt()}%" : "\$${val.toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(55, 182, 233, 1),
                ),
              );
            },
          ),
        ],
      ),
    );

    if (isTotal) {
      return row
          .animate(delay: delay)
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
            duration: 300.ms,
          )
          .then()
          .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1));
    }

    return row
        .animate(delay: delay)
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.1, end: 0);
  }
}

class Clip4Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
