class OnboardingInfo {
  final String imageAsset;
  final String backgroundAsset;
  final String titleLine1;
  final String titleLine2;
  final String descLine1;
  final String descLine2;
  final bool? showZoomCircle;

  OnboardingInfo({
    required this.imageAsset,
    required this.backgroundAsset,
    required this.titleLine1,
    required this.titleLine2,
    required this.descLine1,
    required this.descLine2,
    this.showZoomCircle,
  });
}