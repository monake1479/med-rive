import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart';

enum StartupStatus { loading, onboarding, ready, failure }

extension StartupStatusExtension on StartupStatus {
  bool get isInOnboarding => this == StartupStatus.onboarding;
  bool get isReady => this == StartupStatus.ready;
  bool get isFailure => this == StartupStatus.failure;
}

@injectable
class StartupCubit extends Cubit<StartupStatus> {
  StartupCubit(this._getOnboardingStatusUseCase) : super(StartupStatus.loading);
  final GetOnboardingStatusUseCase _getOnboardingStatusUseCase;

  Future<void> start() async {
    emit(StartupStatus.loading);
    try {
      final onboarded = await _getOnboardingStatusUseCase();
      if (isClosed) return;
      emit(onboarded ? StartupStatus.ready : StartupStatus.onboarding);
    } catch (error, stack) {
      addError(error, stack);
      if (!isClosed) {
        emit(StartupStatus.failure);
      }
    }
  }
}
