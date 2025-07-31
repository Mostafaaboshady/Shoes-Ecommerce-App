part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  final int currentPage;

  const OnboardingState({this.currentPage = 0});

  @override
  List<Object> get props => [currentPage];
}