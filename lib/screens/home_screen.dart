import 'package:flutter/material.dart';
import 'package:freewheel_mart/screens/detail_screen.dart';
import 'package:freewheel_mart/utils/transition.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> bicycle = [
    {
      "image": "assets/images/bicycle2.png",
      "name": "Kiross",
      "price": 1599.99,
      "description":
          "The Kiross is a high-performance road bike designed for speed and agility. Featuring an ultra-lightweight carbon fiber frame and precision Shimano gearing, it's perfect for both competitive racing and long-distance endurance rides. The aerodynamic design ensures minimal drag, while the vibration-dampening technology provides a smooth ride on uneven surfaces.",
      "specification":
          "Frame: Ultra-light Carbon Fiber\nGroupset: Shimano Ultegra 11-speed\nBrakes: Hydraulic Disc Brakes\nWeight: 7.2kg\nWheels: 700c Aero Aluminum",
    },
    {
      "image": "assets/images/bicycle3.png",
      "name": "GT Bike",
      "price": 2599.99,
      "description":
          "The GT Bike is an all-terrain beast built for the toughest trails. With its advanced dual-suspension system and rugged aluminum frame, it offers unmatched control and stability on steep descents and rocky paths. The wide-range drivetrain allows for easy climbing, while the puncture-resistant tires ensure you stay on track no matter the conditions.",
      "specification":
          "Frame: 6061 T6 Aluminum\nSuspension: RockShox 150mm Travel\nDrivetrain: SRAM Eagle 12-speed\nTires: 29x2.4 Maxxis Minion\nSeatpost: Dropper Post",
    },
    {
      "image": "assets/images/bicycle4.png",
      "name": "Scott",
      "price": 2399.99,
      "description":
          "The Scott is the ultimate urban commuter, blending style with functionality. Its sleek geometry and internal gear hub provide a low-maintenance, reliable ride through city streets. Integrated lights and a lightweight frame make it the perfect choice for night rides and quick cross-town trips. Experience comfort with the ergonomic saddle and grips.",
      "specification":
          "Frame: Lightweight Alloy\nHub: Shimano Alfine 8-speed Internal\nLights: Integrated LED (Front/Rear)\nBrakes: Mechanical Disc\nWeight: 10.5kg",
    },
    {
      "image": "assets/images/bicycle5.png",
      "name": "Ross",
      "price": 1999.99,
      "description":
          "The Ross is a versatile gravel bike that blurs the line between road and off-road. Equipped with multiple mount points for racks and bottles, it's ready for any bikepacking adventure. The flared handlebars and stable geometry provide confidence on loose gravel, while the fast-rolling tires keep you moving quickly on the pavement.",
      "specification":
          "Frame: Butted Aluminum Gravel\nFork: Full Carbon Gravel Fork\nDrivetrain: Shimano GRX 2x10\nTires: 700x40c Gravel Specific\nMounts: Fenders, Racks, 3x Bottle",
    },
  ];

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
                clipper: ClipHomeClipper(),
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
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RotatedBox(
              quarterTurns: 1,
              child: Text(
                "FREEWHEEL",
                style: GoogleFonts.allertaStencil(
                  fontSize: 125,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 80,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // 1. Top header "Choose Your Bicycle" slides down
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 310,
                          child: Text(
                            "Choose Your Bicycle",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                            Icons.search,
                            size: 30,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ],
                  ).animate().slideY(begin: -1, end: 0, duration: 400.ms),
                  const SizedBox(height: 20),
                  // 2. Featured banner card zooms in slightly with shimmer
                  Container(
                        height: 240,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            width: 2,
                            color: const Color.fromRGBO(0, 0, 0, 0),
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(53, 63, 84, 0.6),
                              Color.fromRGBO(34, 40, 52, 0.6),
                            ],
                            end: Alignment.bottomRight,
                            begin: Alignment.topLeft,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(4, 7),
                              blurRadius: 7,
                              spreadRadius: 0,
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/bicycle1.png",
                              height: 210,
                              width: 210,
                              fit: BoxFit.fill,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "EXTREME",
                                  style: GoogleFonts.allertaStencil(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(
                                      255,
                                      255,
                                      255,
                                      1,
                                    ),
                                  ),
                                ),
                                // 5. "30% OFF" badge pulses once after card loads
                                Text(
                                      "30% OFF",
                                      style: GoogleFonts.poppins(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          1,
                                        ),
                                      ),
                                    )
                                    .animate(delay: 800.ms)
                                    .scale(
                                      begin: const Offset(1, 1),
                                      end: const Offset(1.2, 1.2),
                                      duration: 200.ms,
                                      curve: Curves.easeInOut,
                                    )
                                    .then()
                                    .scale(
                                      begin: const Offset(1.2, 1.2),
                                      end: const Offset(1, 1),
                                      duration: 200.ms,
                                    ),
                              ],
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                      )
                      .shimmer(duration: 1.seconds, color: Colors.white24),
                  const SizedBox(height: 20),
                  // 3. Category filter icons staggered bounce-in
                  Row(
                    children:
                        [
                              _buildCategoryItem(
                                "assets/images/content1.png",
                                isSelected: true,
                              ),
                              const SizedBox(width: 20),
                              _buildCategoryItem("assets/images/content2.png"),
                              const SizedBox(width: 20),
                              _buildCategoryItem("assets/images/content3.png"),
                              const SizedBox(width: 20),
                              _buildCategoryItem("assets/images/content4.png"),
                            ]
                            .animate(interval: 100.ms)
                            .scale(
                              begin: const Offset(0, 0),
                              end: const Offset(1, 1),
                              curve: Curves.bounceOut,
                              duration: 400.ms,
                            ),
                  ),
                  const SizedBox(height: 20),
                  // 4. Product cards slide up staggered
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(bicycle.length, (index) {
                      return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                DiagonalWipePageRoute(
                                  page: DetailScreen(data: bicycle[index]),
                                ),
                              );
                            },
                            child: Container(
                              height: 255,
                              width: 180,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(0, 0, 0, 0),
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(53, 63, 84, 0.6),
                                    Color.fromRGBO(34, 40, 52, 0.6),
                                  ],
                                  end: Alignment.bottomRight,
                                  begin: Alignment.topLeft,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(4, 7),
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    bicycle[index]["image"],
                                    height: 155,
                                    width: 170,
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    "Road Bike",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        195,
                                        195,
                                        195,
                                        1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    bicycle[index]["name"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Text(
                                        "\$",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            195,
                                            195,
                                            195,
                                            1,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${bicycle[index]["price"]}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            195,
                                            195,
                                            195,
                                            1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .moveY(
                            begin: 100,
                            end: 0,
                            delay: (index * 150).ms,
                            duration: 600.ms,
                            curve: Curves.easeOut,
                          )
                          .fadeIn(delay: (index * 150).ms);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String iconPath, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            width: 1,
            color: isSelected
                ? const Color.fromRGBO(255, 255, 255, 0.2)
                : const Color.fromRGBO(0, 0, 0, 0.2),
          ),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color.fromRGBO(55, 182, 233, 1),
                    Color.fromRGBO(72, 92, 236, 1),
                    Color.fromRGBO(75, 76, 237, 1),
                  ],
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft,
                )
              : const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(161, 161, 161, 1),
                  ],
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft,
                ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.25),
            ),
          ],
        ),
        child: Center(child: Image.asset(iconPath)),
      ),
    );
  }
}

class Clip2Clipper extends CustomClipper<Path> {
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

class ClipHomeClipper extends CustomClipper<Path> {
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
