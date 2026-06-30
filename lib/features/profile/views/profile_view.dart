import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:freewheel_mart/features/auth/data/auth_screen.dart';
import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUserModel;

    // Fallback descriptors if Firestore synchronization is processing
    final String name = user?.name ?? "Rider Member";
    final String email = user?.mail ?? "rider@velohub.com";
    final String balance = user?.balance ?? "0.00";

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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(height: 40),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "My Profile",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xff37B6E9), Color(0xff4B4CED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff4B4CED).withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty
                                ? SouthernSubstring(name)
                                : "R", // FIXED: Corrected ternary operator syntax
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- 2. QUICK ACCOUNT METRICS MATRIX ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff242C3B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricColumn(
                          "Wallet Balance",
                          "\$$balance",
                          Icons.account_balance_wallet,
                          context,
                        ),
                        Container(height: 40, width: 1, color: Colors.white10),
                        _buildMetricColumn(
                          "Membership",
                          "Premium",
                          Icons.stars,
                          context,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- 3. DASHBOARD ACTION MENU OPTIONS ---
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xff242C3B),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _buildMenuRow(
                        Icons.shopping_bag_outlined,
                        "Order History",
                        () {},
                      ),
                      _buildDivider(),
                      _buildMenuRow(
                        Icons.location_on_outlined,
                        "Shipping Addresses",
                        () {},
                      ),
                      _buildDivider(),
                      _buildMenuRow(
                        Icons.security_rounded,
                        "Account Security",
                        () {},
                      ),
                      _buildDivider(),
                      _buildMenuRow(
                        Icons.help_outline_rounded,
                        "Help & Support",
                        () {},
                      ),
                      _buildDivider(),

                      // --- LOGOUT ACTION ---
                      _buildMenuRow(Icons.logout_rounded, "Sign Out", () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          // Completely reset back to the login framework layout
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const AuthScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      }, isDestructive: true),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 120,
                ), // Prevents cutoff beneath floating frosted glass bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Substring helper function to get initials for profile picture
  String SouthernSubstring(String str) {
    if (str.isEmpty) return "";
    List<String> words = str.trim().split(" ");
    if (words.length > 1 && words[1].isNotEmpty) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return str[0].toUpperCase();
  }

  Widget _buildMetricColumn(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xff4B4CED), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMenuRow(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDestructive ? Colors.redAccent : Colors.white70,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Colors.redAccent
              : Colors.white, // FIXED: Corrected reference string syntax
          fontSize: 15,
          fontWeight: isDestructive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing: isDestructive
          ? null
          : const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.04),
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
