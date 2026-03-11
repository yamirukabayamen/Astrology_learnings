import 'package:asrology/view/role_selection/role_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../routes/SessionManger.dart';
import '../routes/app_routes.dart';
import 'admin/dashboard.dart';
import 'customer/dashboard_view.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    super.initState();
    navigateNext();
  }

  Future<void> navigateNext() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay

    final isLoggedIn = await SessionManager.isLoggedIn();
    final role = await SessionManager.getUserRole();

    if (!isLoggedIn) {
      Get.offAll(() => const RoleSelectionView());
    } else {
      // Logged in user
      if (role == 'admin') {
        Get.offAll(() => AdminBottom());
      } else {
        Get.offAll(() => const DashboardView());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// LOGO
            Container(
              height: 150.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/ALogo/logo.png',fit: BoxFit.fill,),
            ),

            SizedBox(height: 12.h),

            /// TITLE
            Text(
              'Email Auth App',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10.h),

            /// LOADER
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
