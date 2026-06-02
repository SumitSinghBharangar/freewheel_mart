import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  List<Widget> screens = [
    // const Home(),
    // const Shopping(),
    // const Wallet(),
    // const Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: screens[_currentIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child:
                Container(
                  height: 70,
                  color: const Color.fromRGBO(36, 44, 59, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildBottomAppBarItem(
                            index: 0,
                            iconPath: "assets/navigation/house.png",
                          ),
                          _buildBottomAppBarItem(
                            index: 1,
                            iconPath: "assets/navigation/shopping-bag.png",
                          ),
                          _buildBottomAppBarItem(
                            index: 2,
                            iconPath: "assets/navigation/wallet.png",
                          ),
                          _buildBottomAppBarItem(
                            index: 3,
                            iconPath: "assets/navigation/user.png",
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().slideY(
                  begin: 1,
                  end: 0,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBarItem({
    required int index,
    required String iconPath,
  }) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    const Color.fromRGBO(55, 182, 233, 1),
                    const Color.fromRGBO(75, 76, 237, 1),
                  ]
                : [Colors.transparent, Colors.transparent],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(13),
            topRight: Radius.circular(13),
          ),
        ),
        child: Center(
          child: Image.asset(iconPath, height: 30, width: 30, fit: BoxFit.cover)
              .animate(target: isSelected ? 1 : 0)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                curve: Curves.elasticOut,
                duration: 400.ms,
              ),
        ),
      ),
    );
  }
}
