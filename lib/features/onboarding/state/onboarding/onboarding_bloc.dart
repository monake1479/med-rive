import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart';
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_read_exception.dart';
import 'package:med_rive/common/error_handling/local_storage_exceptions/local_storage_write_exception.dart';
import 'package:med_rive/common/error_handling/med_rive_exception.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@lazySingleton
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required this._getOnboardingStatusUseCase,
    required this._setOnboardingStatusUseCase,
  }) : super(const OnboardingState()) {
    on<OnboardingEvent>((event, emit) async {
      switch (event) {
        case OnboardingStarted():
          await _onStarted(event, emit);

        case SetOnboarding():
          await _onSetOnboarding(event, emit);
      }
    }, transformer: sequential());
  }
  final GetOnboardingStatusUseCase _getOnboardingStatusUseCase;
  final SetOnboardingStatusUseCase _setOnboardingStatusUseCase;

  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      final isOnboarded = await _getOnboardingStatusUseCase.call();

      emit(
        state.copyWith(
          status: isOnboarded
              ? OnboardingStatus.completed
              : OnboardingStatus.inProgress,
        ),
      );
    } on LocalStorageReadException catch (error, stacktrace) {
      addError(error, stacktrace);
      emit(state.copyWith(status: OnboardingStatus.failure, exception: error));
      return;
    }
  }

  Future<void> _onSetOnboarding(
    SetOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));

    try {
      await _setOnboardingStatusUseCase.call(event.onboarded);
    } on LocalStorageWriteException catch (error, stacktrace) {
      addError(error, stacktrace);
      emit(state.copyWith(status: OnboardingStatus.failure, exception: error));
      return;
    }

    emit(
      state.copyWith(
        status: event.onboarded
            ? OnboardingStatus.completed
            : OnboardingStatus.inProgress,
      ),
    );
  }
}
