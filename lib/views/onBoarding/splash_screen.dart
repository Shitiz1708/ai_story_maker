import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/views/brand/add_brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/register_screen.dart';
import '../dashboard/dashboard.dart';
import 'onBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    GetStorage().writeIfNull('isFirstTime', true);
    GetStorage().writeIfNull('isLogged', false);
    firebaseController.checkBrand();
    Future.delayed(const Duration(seconds: 3), () {
      if (GetStorage().read('isFirstTime') == true) {
        GetStorage().write('isFirstTime', false);
        Get.offAll(() => const OnboardingScreen());
      } else {
        GetStorage().write('isFirstTime', false);
        if (GetStorage().read('isLogged') == true) {
          if (firebaseController.isEmpty) {
            Get.offAll(() => const BrandManagementScreen());
          } else {
            Get.offAll(() => const DashBoardScreen());
          }
        } else {
          GetStorage().write('isFirstTime', false);
          Get.offAll(() => const RegisterView());
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          const BackgroundImage(),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    'assets/bg.png',
                    fit: BoxFit.contain,
                  ),
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                // Text(
                //   "My Epic AI Stories",
                //   style: sfBold.copyWith(color: Colors.white, fontSize: 20),
                // ),
                const SizedBox(
                  height: 20,
                ),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ],
            ),
          ),
          //circular progress indicator
        ],
      ),
    );
  }
}
