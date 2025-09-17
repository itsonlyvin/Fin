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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(TSizes.spaceBtwSections),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ////
            GestureDetector(
              onTap: () => Get.to(
                () => const LoginScreen(
                  logo: TImages.finDarkAppLogo,
                  color1: TColors.fin1,
                  color2: TColors.fin2,
                  isfin: true,
                ),
              ),
              child: SpecialColumn(
                dark: dark,
                child: Image(
                  height: 150,
                  image: AssetImage(
                      dark ? TImages.finDarkAppLogo : TImages.finLightAppLogo),
                ),
              ),
            ),

/////
            GestureDetector(
              onTap: () => Get.to(
                () => const LoginScreen(
                  logo: TImages.openDarkAppLogo,
                  color1: Color.fromARGB(255, 203, 140, 140),
                  color2: Color.fromARGB(255, 206, 103, 197),
                  isfin: false,
                ),
              ),
              child: SpecialColumn(
                dark: dark,
                child: Image(
                  height: 150,
                  image: AssetImage(dark
                      ? TImages.openDarkAppLogo
                      : TImages.openLightAppLogo),
                ),
              ),
            ),

            GestureDetector(
              onTap: () => Get.to(
                () => const LoginScreen(
                  admin: true,
                  logo: TImages.finDarkAppLogo,
                  color1: TColors.fin1,
                  color2: TColors.fin2,
                  isfin: true,
                ),
              ),
              child: SpecialColumn(
                  dark: dark,
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Text(
                        "ADMIN",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
