import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/specialColumn.dart';
import 'package:t_store/features/authentication/screens/login/login.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class Onboardging extends StatelessWidget {
  const Onboardging({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    void navigateWithTransition(Widget page) {
      Get.to(
        () => page,
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101010) : Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.spaceBtwSections,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // App title or header
              Text(
                "Choose Your Portal",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black87,
                    ),
              ),
              const SizedBox(height: 40),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildLoginCard(
                      context: context,
                      dark: dark,
                      tag: 'fin_logo',
                      image: dark
                          ? TImages.finDarkAppLogo
                          : TImages.finLightAppLogo,
                      title: "FIN Login",
                      subtitle: "FIN LOGIN",
                      color1: TColors.fin1,
                      color2: TColors.fin2,
                      onTap: () => navigateWithTransition(
                        const LoginScreen(
                          logo: TImages.finDarkAppLogo,
                          color1: TColors.fin1,
                          color2: TColors.fin2,
                          isfin: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildLoginCard(
                      context: context,
                      dark: dark,
                      tag: 'open_logo',
                      image: dark
                          ? TImages.openDarkAppLogo
                          : TImages.openLightAppLogo,
                      title: "OPEN Login",
                      subtitle: "OPEN ARMS LOGIN",
                      color1: const Color.fromARGB(255, 203, 140, 140),
                      color2: const Color.fromARGB(255, 206, 103, 197),
                      onTap: () => navigateWithTransition(
                        const LoginScreen(
                          logo: TImages.openDarkAppLogo,
                          color1: Color.fromARGB(255, 203, 140, 140),
                          color2: Color.fromARGB(255, 206, 103, 197),
                          isfin: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildAdminCard(
                      context: context,
                      dark: dark,
                      onTap: () => navigateWithTransition(
                        const LoginScreen(
                          admin: true,
                          logo: TImages.finDarkAppLogo,
                          color1: TColors.fin1,
                          color2: TColors.fin2,
                          isfin: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Regular login card (FIN, OPEN)
  Widget _buildLoginCard({
    required BuildContext context,
    required bool dark,
    required String tag,
    required String image,
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1.withOpacity(0.8), color2.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            children: [
              Hero(
                tag: tag,
                child: Image(
                  height: 100,
                  image: AssetImage(image),
                ),
              ),
              // const SizedBox(height: 15),
              // Text(
              //   title,
              //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              // ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Admin card
  Widget _buildAdminCard({
    required BuildContext context,
    required bool dark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColors.fin1.withOpacity(0.8),
              TColors.fin2.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
          child: Column(
            children: [
              Hero(
                tag: 'admin_text',
                child: Text(
                  "ADMIN",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "ADMINISTRATOR ACCESS",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
