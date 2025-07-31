import 'package:flutter/material.dart';
import '/core/constants/colors.dart';
import '/core/widgets/custom_text.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String backgroundImage;
  final String title1;
  final String title2;
  final String description1;
  final String description2;
  final bool? showZoomCircle;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.backgroundImage,
    required this.title1,
    required this.title2,
    required this.description1,
    required this.description2,
    required this.showZoomCircle,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 3),
          SizedBox(
            height: screenHeight * 0.4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  color: AppColors.offWhite,
                  backgroundImage,
                  height: screenHeight * 0.3,
                  errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
                ),
                Image.asset(
                  image,
                  height: screenHeight * 0.35,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: screenHeight * 0.35,
                      color: AppColors.white,
                      child: const Center(child: Text('Image not found')),
                    );
                  },
                ),
                _buildDot(top: 80, left: 55),
                _buildDot(bottom: 20, left: 20),
                _buildDot(bottom: 50, right: 20),

                if (showZoomCircle == true)
                  Positioned(
                    bottom: 55,
                    right: 50,
                    child: _buildZoomCircle(context),
                  ),

              ],
            ),
          ),
          const SizedBox(height: 48),

          CustomText(
            text: title1,
            fontSize: 40,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            text: title2,
            fontSize: 40,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),
          CustomText(
            text: description1,
            fontSize: 20,
            color: AppColors.grey,
          ),
          CustomText(
            text: description2,
            fontSize: 20,
            color: AppColors.grey,
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }

  Widget _buildDot({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Image.asset(
        'assets/onboarding/dottop.png',
        width: 15,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildZoomCircle(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          )
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1.8,
              child: Transform.translate(
                offset: const Offset(-10, -8),
                child: Image.asset(
                  image,
                  height: MediaQuery.of(context).size.height * 0.35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
