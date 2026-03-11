import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import '../../controller/video_controller.dart';
import '../../routes/SessionManger.dart';
import 'login_view.dart';
import 'profile_page.dart';
import 'video_player_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final VideoController videoController = Get.put(VideoController());
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentIndex = 0;

  final List<String> imageUrls = List.generate(
    16,
    (index) => "https://picsum.photos/200?random=${Random().nextInt(10)}",
  );
  @override
  void initState() {
    videoController.fetchVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 NORMAL APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        centerTitle: true,
        elevation: 0,

        // 🔹 Logout
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            showLogoutDialog();
          },
        ),

        // 🔹 Thirukural Title
        title: Text(
          "அகர முதல எழுத்தெல்லாம் ஆதி\nபகவன் முதற்றே உலகு",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.sp,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
        ),

        // 🔹 Profile
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Get.to(() => ProfileScreen());
            },
          ),
        ],
      ),

      // 🔹 BODY SECTION
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C0B20), Color(0xFF1A1A2E)],
            stops: [0.0, 5.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Obx(() {
          return RefreshIndicator(
            color: const Color(0xFF6A5AE0),
            onRefresh: videoController.fetchVideos,
            child: videoController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back 👋",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp, // 🔽 reduced
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Upgrade Your Knowledge",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp, // 🔽 max under 15
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                height: 3.h, // 🔽 reduced
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6A5AE0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CarouselSlider.builder(
                          carouselController: _carouselController,
                          itemCount: imageUrls.length,
                          options: CarouselOptions(
                            height: 180,
                            autoPlay: true,
                            viewportFraction: 0.9,
                            enlargeCenterPage: true,
                            autoPlayInterval: const Duration(seconds: 10),
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                          itemBuilder: (context, index, realIndex) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrls[index]),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 6.h),

                        // 🔹 Indicator
                        Center(
                          child: AnimatedSmoothIndicator(
                            activeIndex: currentIndex,
                            count: 3,
                            effect: const WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: Color(0xFF6A5AE0),
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          child: Container(
                            height: 80.h,

                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF26263A),
                              borderRadius: BorderRadius.circular(
                                14,
                              ), // 🔽 slightly reduced
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  color: const Color(0xFF6A5AE0),
                                  size: 22.sp, // 🔽 reduced
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    "Explore high quality lessons designed to boost your skills.",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.sp, // 🔽 under 15
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Transform.rotate(
                              angle: -0.0,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                alignment: Alignment.centerLeft,
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF6A5AE0),
                                          Color(0xFF8E7BFF),
                                        ],
                                      ).createShader(bounds),
                                  child: Text(
                                    "Learn More",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),
                          ],
                        ),

                        // =========================
                        // 🔹 VIDEO SECTION
                        // =========================
                        if (!videoController.hasPaid.value)
                          buildFreeTrialVideos()
                        else
                          buildBasicVideos(),
                      ],
                    ),
                  ),
          );
        }),
      ),
    );
  }

  Widget buildFreeTrialVideos() {
    return Obx(() {
      return Column(
        children: videoController.freeVideos.asMap().entries.map((entry) {
          int index = entry.key;
          var video = entry.value;

          return GestureDetector(
            onTap: () {
              Get.to(
                () => VideoPlayerView(
                  urls: videoController.freeVideos
                      .map((e) => e.videoUrl)
                      .toList(),
                  startIndex: index,
                ),
              );

              Future.delayed(const Duration(seconds: 5), () {
                showPaymentDialog();
              });
            },
            child: buildVideoCard(isFree: true),
          );
        }).toList(),
      );
    });
  }

  void showPaymentDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2F),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Lock Icon with Gradient Circle
              Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
                  ),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Title
              const Text(
                "Unlock Premium Videos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Subtitle
              const Text(
                "Upgrade your learning experience and get access to all Basic level lessons.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Features List
              _buildFeatureRow("Unlimited Basic Videos"),
              _buildFeatureRow("HD Quality Content"),
              _buildFeatureRow("Lifetime Access"),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: const Color(0xFF6A5AE0),
                  ),
                  child: const Text(
                    "Pay ₹99.00",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Cancel Button
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Maybe Later",
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF6A5AE0), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVideoCard({required bool isFree}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 🔹 Background Image
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("assets/ALogo/play_image.png", fit: BoxFit.cover),
            ),
            // Image.network(
            //   "https://picsum.photos/600/400?random=${Random().nextInt(100)}",
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            // ),

            // 🔹 Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // 🔹 Video Title + Subtitle
            Positioned(
              bottom: 20,
              left: 20,
              right: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFree ? "Free Introduction Class" : "Basic Level Lesson",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 FREE Badge (Improved)
            if (isFree)
              Positioned(
                top: 12,
                right: 16,
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "FREE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

            // 🔹 Play Button (Premium Style)
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.6),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBasicVideos() {
    return Obx(() {
      return Column(
        children: videoController.entryVideos.map((video) {
          return GestureDetector(
            onTap: () {
              Get.to(
                () => VideoPlayerView(
                  urls: videoController.entryVideos
                      .map((e) => e.videoUrl)
                      .toList(),
                  startIndex: videoController.entryVideos.indexOf(video),
                ),
              );
            },
            child: buildVideoCard(isFree: false),
          );
        }).toList(),
      );
    });
  }
  void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                size: 50,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 15),

              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(() => LoginView());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
