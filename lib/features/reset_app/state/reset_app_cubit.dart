import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/onboarding/use_cases/reset_app_use_case.dart';

enum ResetAppStatus { initial, inProgress, success, failure }

@injectable
class ResetAppCubit extends Cubit<ResetAppStatus> {
  ResetAppCubit(this._resetAppUseCase) : super(ResetAppStatus.initial);
  final ResetAppUseCase _resetAppUseCase;

  Future<void> reset() async {
    if (state == ResetAppStatus.inProgress || state == ResetAppStatus.success) {
      return;
    }
    emit(ResetAppStatus.inProgress);
    try {
      await _resetAppUseCase();
      if (!isClosed) emit(ResetAppStatus.success);
    } catch (error, stack) {
      addError(error, stack);
      if (!isClosed) emit(ResetAppStatus.failure);
    }
  }
}
