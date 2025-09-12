import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';
import 'package:t_store/features/app/screens/employee/profile/widgets/header.dart';
import 'package:t_store/features/app/screens/employee/profile/widgets/profile.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: false,
        title: Text('Profile'),
      ),

      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TCircularImage(
                      image: TImages.facebook,
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              /// Details
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              const Divider(),
              // const SizedBox(
              //   height: TSizes.spaceBtwItems,
              // ),

              // /// Heading Profile Info
              // const TSectionHeading(
              //   title: 'Profile Informations',
              //   showActionButton: false,
              // ),
              // const SizedBox(
              //   height: TSizes.spaceBtwItems,
              // ),

              // TProfileMenu(
              //   onPressed: () {},
              //   title: 'Name',
              //   value: 'Texts Texts ',
              // ),
              // TProfileMenu(
              //   onPressed: () {},
              //   title: 'Usernmae',
              //   value: 'Texts Texts ',
              // ),

              // const SizedBox(
              //   height: TSizes.spaceBtwItems / 2,
              // ),
              // const Divider(),
              // const SizedBox(
              //   height: TSizes.spaceBtwItems,
              // ),

              /// Heading Personal Info
              const TSectionHeading(
                title: 'Personal Informations',
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TProfileMenu(
                onPressed: () {},
                title: 'Name',
                value: 'Texts Texts ',
              ),
              TProfileMenu(
                onPressed: () {},
                title: 'User ID',
                value: "448",
                icon: Iconsax.copy,
              ),
              TProfileMenu(
                  onPressed: () {}, title: 'E-mail', value: 'mial@gamil.com'),
              TProfileMenu(
                  onPressed: () {}, title: 'Phone Number', value: '1234567890'),
              // TProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              // TProfileMenu(
              //     onPressed: () {},
              //     title: 'Date of Birth',
              //     value: '10 Dec, 1996'),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Center(
                child: TextButton(
                    onPressed: () => Get.to(
                          () => const Onboardging(),
                        ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
