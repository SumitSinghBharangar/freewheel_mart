import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:freewheel_mart/common/buttons/dynamic_button.dart';
import 'package:freewheel_mart/common/enum.dart';

import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/screens/bottom_navigation.dart';
import 'package:freewheel_mart/splash_screen.dart';
import 'package:freewheel_mart/utils/transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _currentMode = AuthMode.login;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _switchMode(AuthMode mode) {
    if (context.read<AuthProvider>().isLoading) return;
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xffE53935) : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSubmit(AuthProvider authProvider) async {
    // Basic structural validation checks
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackBar("Please fill out required credentials.", true);
      return;
    }

    if (_currentMode == AuthMode.signup &&
        _nameController.text.trim().isEmpty) {
      _showSnackBar("Please specify your full name.", true);
      return;
    }

    bool success = false;

    if (_currentMode == AuthMode.login) {
      success = await authProvider.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (success) {
        _showSnackBar("Welcome back to Free-Wheel", false);
        Navigator.pushReplacement(
          context,
          DiagonalWipePageRoute(page: BottomNavigation()),
        );
      }
    } else if (_currentMode == AuthMode.signup) {
      success = await authProvider.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      if (success) {
        _showSnackBar("Registration complete! Account created.", false);
        _switchMode(AuthMode.login);
      }
    }

    if (!success && mounted && authProvider.errorMessage != null) {
      _showSnackBar(authProvider.errorMessage!, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    double yRotation = _currentMode == AuthMode.signup ? pi : 0.0;
    // Forgot Password = 180 degrees (Flipped vertically)
    double xRotation = _currentMode == AuthMode.forgotPassword ? pi : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xff1A1A1A), // Racing Slate Black Background
      body: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(36, 44, 59, 1),
          ).animate().fadeIn(duration: 300.ms),
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
                        "FREEWHEEL",
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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(xRotation, yRotation),
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                    builder: (context, Offset angle, child) {
                      // Check which side of the animation card faces the camera
                      final isSignUpFront = angle.dy >= pi / 2;
                      final isForgotFront = angle.dx >= pi / 2;

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(
                            3,
                            2,
                            0.001,
                          ) // Adds 3D perspective depth effect
                          ..rotateX(angle.dx)
                          ..rotateY(angle.dy),
                        alignment: Alignment.center,
                        child:
                            Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24.0),
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
                                  child: isForgotFront
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateX(
                                              pi,
                                            ), // Correct mirror text orientation
                                          child: _buildForgotPasswordView(
                                            authProvider,
                                          ),
                                        )
                                      : isSignUpFront
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateY(
                                              pi,
                                            ), // Correct mirror text orientation
                                          child: _buildSignupView(authProvider),
                                        )
                                      : _buildLoginView(authProvider),
                                )
                                .animate()
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1, 1),
                                  duration: 600.ms,
                                )
                                .shimmer(
                                  duration: 1.seconds,
                                  color: Colors.white24,
                                ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginView(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sign in to gear up for your next ride',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _switchMode(AuthMode.forgotPassword),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Color(0xffE53935), fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 8),
        DynamicButton(
          isLoading: authProvider.isLoading,
          onPressed: () => _handleSubmit(authProvider),
          child: Text("SIGN IN"),
        ),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            GestureDetector(
              onTap: () => _switchMode(AuthMode.signup),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Color(0xffE53935),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignupView(AuthProvider authprovider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Join the club and explore top-tier equipment',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        const SizedBox(height: 24),
        DynamicButton(
          isLoading: authprovider.isLoading,
          onPressed: () => _handleSubmit(authprovider),
          child: Text("REGISTER"),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already a member? ",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            GestureDetector(
              onTap: () => _switchMode(AuthMode.login),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Color(0xffE53935),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForgotPasswordView(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter your registered email to receive a recovery link',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 24),
        DynamicButton(
          onPressed: () async {
            final email = _emailController.text.trim();

            if (email.isEmpty) {
              _showSnackBar("Please enter your email address.", true);
              return;
            }

            // Run the recovery network call
            bool linkSent = await authProvider.sendPasswordReset(email: email);

            if (linkSent && mounted) {
              _showSnackBar(
                "Reset link sent! Please check your email inbox.",
                false,
              );
              // Smoothly flip the box back to the regular sign-in mode
              _switchMode(AuthMode.login);
            } else if (!linkSent &&
                mounted &&
                authProvider.errorMessage != null) {
              _showSnackBar(authProvider.errorMessage!, true);
            }
          },
          isLoading: authProvider.isLoading,
          child: Text("SEND RESET LINK"),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () => _switchMode(AuthMode.login),
            icon: const Icon(
              Icons.arrow_back,
              size: 16,
              color: Color(0xffE53935),
            ),
            label: const Text(
              'Back to Login',
              style: TextStyle(
                color: Color(0xffE53935),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,

    bool isphone = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isphone ? TextInputType.phone : TextInputType.name,

      style: const TextStyle(color: Colors.white, fontSize: 14),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white, size: 20),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xff1A1A1A,
          ), // Dark contrast action button
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
