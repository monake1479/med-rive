part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

final class SetOnboarding extends OnboardingEvent {
  const SetOnboarding(this.onboarded);

  final bool onboarded;

  @override
  List<Object?> get props => [onboarded];
}
