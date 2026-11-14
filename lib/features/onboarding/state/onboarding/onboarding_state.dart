part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, loading, completed, inProgress, failure }

extension OnboardingStatusExtension on OnboardingStatus {
  bool get isInProgress => this == OnboardingStatus.inProgress;
  bool get isCompleted => this == OnboardingStatus.completed;
  bool get isLoading => this == OnboardingStatus.loading;
}

final class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.exception,
  });

  final OnboardingStatus status;
  final MedRiveException? exception;

  OnboardingState copyWith({
    OnboardingStatus? status,
    MedRiveException? exception,
  }) {
    return OnboardingState(status: status ?? this.status, exception: exception);
  }

  @override
  List<Object?> get props => [status, exception];
}
