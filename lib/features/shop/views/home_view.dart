import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/features/shop/data/product_model.dart';
import 'package:freewheel_mart/features/shop/provider/product_provider.dart';
import 'package:freewheel_mart/features/shop/views/widgets/categories_chips.dart';
import 'package:freewheel_mart/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final String displayName =
        FirebaseAuth.instance.currentUser!.displayName ?? "name";

    return Scaffold(
      backgroundColor: const Color(0xff1A1A1A),
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

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xff1A1A1A),
                expandedHeight: 80,
                floating: true,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 45,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome back,",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              "$displayName 👋",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff242C3B),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- 2. PROMOTIONAL INSPIRED BANNER ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff4B4CED), Color(0xff3435A7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "NEW ARRIVALS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Carbon Enduro 2026\nUp To 20% Off",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight(600),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- 3. FILTER ENGAGEMENT BAR ---
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CategoryChips(),
                ),
              ),

              // --- 4. STREAM DRIVEN PRODUCT GRID FEED ---
              StreamBuilder<List<ProductModel>>(
                stream: productProvider.productsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff4B4CED),
                          ),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.directions_bike_outlined,
                              size: 48,
                              color: Colors.white24,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "No items found in this section",
                              style: TextStyle(color: Colors.white38),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: 100,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio:
                                0.75, // Perfect ratio sizing framework
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = products[index];
                        // Temporary structural cell wrapper before card file implementation
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff242C3B),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.image_outlined,
                                    color: Colors.white24,
                                    size: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.name ?? "Unnamed Bike",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${item.price?.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                  color: Color(0xff4B4CED),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      }, childCount: products.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
