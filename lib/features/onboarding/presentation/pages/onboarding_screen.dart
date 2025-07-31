import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:final_project/core/routes/route_names.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:final_project/features/onboarding/models/onboarding_info.dart';
import 'package:final_project/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:final_project/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:final_project/core/widgets/page_indicator_dot.dart';
import 'package:final_project/core/widgets/circle_blob.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final List<OnboardingInfo> pages = [
      OnboardingInfo(
        backgroundAsset: 'assets/onboarding/NIKE.png',
        imageAsset: 'assets/onboarding/shoes1.png',
        titleLine1: 'Start Journey',
        titleLine2: 'With Nike',
        descLine1: 'Smart, Gorgeous & Fashionable',
        descLine2: 'Collection',
      ),
      OnboardingInfo(
          backgroundAsset: 'assets/onboarding/NIKE.png',
          imageAsset: 'assets/onboarding/shoes2.png',
          titleLine1: 'Follow Latest',
          titleLine2: 'Style Shoes',
          descLine1: 'There Are Many Beautiful And',
          descLine2: 'Attractive Plants To Your Room',
          showZoomCircle: true
      ),
      OnboardingInfo(
        backgroundAsset: 'assets/onboarding/NIKE.png',
        imageAsset: 'assets/onboarding/shoes3.png',
        titleLine1: 'Summer Shoes',
        titleLine2: 'Nike 2025',
        descLine1: 'Amet Minim Lit Nodeseru',
        descLine2: 'Saku Nandu sit Alique Dolor',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final isLastPage = state.currentPage == pages.length - 1;
                return Stack(
                  children: [
                    Positioned(
                      top: constraints.maxHeight * 0.1,
                      left: -constraints.maxWidth * 0.2,
                      child: const CircleBlob(color: AppColors.background, radius: 120),
                    ),
                    Positioned(
                      top: constraints.maxHeight * 0.4,
                      right: -constraints.maxWidth * 0.15,
                      child: const CircleBlob(color: AppColors.background, radius: 80),
                    ),
                    Positioned(
                      bottom: constraints.maxHeight * 0.2,
                      left: constraints.maxWidth * 0.1,
                      child: const CircleBlob(color: AppColors.background, radius: 40),
                    ),
                    PageView.builder(
                      controller: pageController,
                      itemCount: pages.length,
                      onPageChanged: (int page) {
                        context.read<OnboardingCubit>().pageChanged(page);
                      },
                      itemBuilder: (context, index) {
                        final pageData = pages[index];
                        return OnboardingPage(
                          image: pageData.imageAsset,
                          backgroundImage: pageData.backgroundAsset,
                          title1: pageData.titleLine1,
                          title2: pageData.titleLine2,
                          description1: pageData.descLine1,
                          description2: pageData.descLine2,
                          showZoomCircle: pageData.showZoomCircle,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 25,
                      left: 25,
                      right: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              pages.length,
                                  (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: PageIndicatorDot(isActive: index == state.currentPage),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: isLastPage ? 150 : 100,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isLastPage) {
                                  context.read<OnboardingCubit>().completeOnboarding();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, RouteNames.signup, (route) => false);
                                } else {
                                  pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.button,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                              child: CustomText(
                                text: isLastPage ? 'Get Started' : 'Next',
                                fontSize: 18,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
