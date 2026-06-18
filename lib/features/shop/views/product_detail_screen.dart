import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/shop/data/product_model.dart'; // Safe typed structure path
import 'package:freewheel_mart/screens/shoping_page.dart';
import 'package:freewheel_mart/utils/transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product; // Replaced Map<String, dynamic> with ProductModel
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
    final product = widget.product;
    final List<String> images =
        (product.images != null && product.images!.isNotEmpty)
        ? product.images!
        : [];

    // Safely format the specifications map into a readable paragraph block
    String specText = "";
    if (product.specifications != null && product.specifications!.isNotEmpty) {
      specText = product.specifications!.entries
          .map((e) => "${e.key}: ${e.value}")
          .join("\n");
    } else {
      specText =
          "No structural metrics specified for this model catalog entry.";
    }

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
                    Expanded(
                      child: Text(
                        product.name ?? "Premium Equipment",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 9. Back arrow button rotates on tap
                    GestureDetector(
                      onTap: () async {
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
                    // 1. Bicycle image slides in from right with rotation (Now reading Cloudinary array)
                    SizedBox(
                      height: 360,
                      width: double.infinity,
                      child: images.isNotEmpty
                          ? PageView.builder(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                if (page == images.length) {
                                  _pageController.jumpToPage(0);
                                } else {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                }
                              },
                              itemCount: images.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CachedNetworkImage(
                                  imageUrl: images[index],
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white24,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.directions_bike_outlined,
                                        size: 80,
                                        color: Colors.white24,
                                      ),
                                );
                              },
                            )
                          : const Icon(
                              Icons.directions_bike,
                              size: 100,
                              color: Colors.white24,
                            ),
                    ),

                    // 3. Image carousel dots animate in with fade
                    if (images.length > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(images.length, (
                          int index,
                        ) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            height: 10.0,
                            width: 10.0,
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
                                onTap: () => setState(
                                  () => _isDescriptionSelected = true,
                                ),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
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
                                      "Description",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => setState(
                                  () => _isDescriptionSelected = false,
                                ),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
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
                                      "Specifications",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
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
                            height: 180,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child:
                                  Text(
                                        _isDescriptionSelected
                                            ? (product
                                                          .description
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? product.description!
                                                  : "No description available.")
                                            : specText,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1,
                                          ),
                                          height: 1.5,
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
              tween: Tween<double>(begin: 0, end: product.price ?? 0.0),
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
                  child: Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

class Clip3Clipper extends CustomClipper<Path> {
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
