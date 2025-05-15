import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/presentations/widgets/onboarding_data.dart';
import 'package:cak_rawit/presentations/widgets/onboarding_template.dart';
import 'package:cak_rawit/router/app_router.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selectedIndex = 0;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(
      initialPage: 0,
      keepPage: true,
      viewportFraction: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(actions: [skipBtn(context), const SizedBox(width: 20)]),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: OnboardingData.onBoardItemList.length,
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (v) {
                  setState(() {
                    selectedIndex = v;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingTemplate(
                    item: OnboardingData.onBoardItemList[index],
                  );
                },
              ),
            ),
            Row(
              children: [
                SizedBox(width: size.width * 0.05),
                Row(
                  children: [
                    ...List.generate(
                      OnboardingData.onBoardItemList.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        height: 8,
                        width: selectedIndex == index ? 24 : 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              selectedIndex == index
                                  ? AppColors().primaryColorGreen
                                  : Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (selectedIndex <
                        OnboardingData.onBoardItemList.length - 1) {
                      controller.animateToPage(
                        selectedIndex + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.popAndPushNamed(
                        context,
                        AppRouter.dashboardScreen,
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors().primaryColorRed,
                    child:
                        selectedIndex !=
                                OnboardingData.onBoardItemList.length - 1
                            ? const Icon(
                              Icons.arrow_forward,
                              size: 30,
                              color: Colors.white,
                            )
                            : Text(
                              "Mulai",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.15),
          ],
        ),
      ),
    );
  }

  GestureDetector skipBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, AppRouter.dashboardScreen);
      },
      child: Text("SKIP", style: Theme.of(context).textTheme.labelLarge),
    );
  }
}
