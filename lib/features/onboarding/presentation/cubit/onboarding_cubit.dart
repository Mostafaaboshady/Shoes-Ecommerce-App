import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_project/main.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void pageChanged(int page) {
    emit(OnboardingState(currentPage: page));
  }

  Future<void> completeOnboarding() async {
    await sharedPreferences.setBool('hasSeenOnboarding', true);
  }
}