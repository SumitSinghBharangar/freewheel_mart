import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/cart/view/cart_view.dart';
import 'package:freewheel_mart/features/shop/views/home_view.dart';
import 'package:freewheel_mart/features/wallet/view/wallet_view.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // Temporary content feeds to verify scrolling visibility behind the bar
  final List<Widget> _views = [
    HomeView(),
    CartView(),
    WalletView(),
    _buildScrollablePlaceholder(
      'User Profile & Controls',
      Colors.deepPurple.shade900,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Dark slate canvas background
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _views[_currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 68,
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(
                0.08,
              ), // Soft highlight border edge
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: -2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ), // Real-time background frosting depth
              child: Container(
                color: Colors.black.withOpacity(
                  0.25,
                ), // Ultra-light semi-transparent backdrop tint
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavButton(
                      index: 0,
                      icon: Icons.explore_outlined,
                      activeIcon: Icons.explore,
                      label: 'Home',
                    ),
                    _buildNavButton(
                      index: 1,
                      icon: Icons.shopping_bag_outlined,
                      activeIcon: Icons.shopping_bag,
                      label: 'Shop',
                    ),
                    _buildNavButton(
                      index: 2,
                      icon: Icons.account_balance_wallet_outlined,
                      activeIcon: Icons.account_balance_wallet,
                      label: 'Wallet',
                    ),
                    _buildNavButton(
                      index: 3,
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- CUSTOM FROSTED ICON BUTTON CONSTRUCTOR ---
  Widget _buildNavButton({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff4B4CED).withOpacity(0.15)
              : Colors.transparent, // Soft glow background fill
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? const Color(0xff4B4CED)
                  : Colors.white60, // Electric blue accent matches splash theme
              size: 24,
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xff4B4CED) : Colors.white38,
                letterSpacing: 0.5,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  // Helper utility to instantiate long lists to easily inspect content passing under the glass bar
  static Widget _buildScrollablePlaceholder(String viewTitle, Color color) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 60, bottom: 100, left: 16, right: 16),
      itemCount: 30,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),

            child: Text(
              viewTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        }
        return Card(
          color: color.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              'Bicycle Equipment Component #$index',
              style: const TextStyle(color: Colors.white70),
            ),
            subtitle: const Text(
              'Tap to view product specification array metrics',
              style: TextStyle(color: Colors.white30),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
          ),
        );
      },
    );
  }
}
