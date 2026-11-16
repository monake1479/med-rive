import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/breathing_pace/use_cases/get_breathing_paces_use_case.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/data/user/use_cases/get_user_use_case.dart';
import 'package:med_rive/common/data/user/use_cases/set_user_pace_use_case.dart';
part 'breath_session_state.dart';

@injectable
class BreathSessionCubit extends Cubit<BreathSessionState> {
  BreathSessionCubit(
    this._getUserUseCase,
    this._setUserPaceUseCase,
    this._getBreathingPacesUseCase,
  ) : super(const BreathSessionState()) {
    unawaited(loadPaces());
    unawaited(loadUser());
  }
  final GetBreathingPacesUseCase _getBreathingPacesUseCase;
  final GetUserUseCase _getUserUseCase;
  final SetUserPaceUseCase _setUserPaceUseCase;

  Future<void> loadPaces() async {
    emit(state.copyWith(pacesStatus: BreathingPacesStatus.loading));
    try {
      final paces = await _getBreathingPacesUseCase();
      if (!isClosed) {
        emit(
          state.copyWith(
            availablePaces: paces,
            pacesStatus: BreathingPacesStatus.ready,
          ),
        );
      }
    } catch (e, s) {
      addError(e, s);
      if (!isClosed) {
        emit(state.copyWith(pacesStatus: BreathingPacesStatus.failure));
      }
    }
  }

  Future<void> loadUser() async {
    if (state.status == ProfileStatus.ready) return;

    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await _getUserUseCase();
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProfileStatus.ready,
            user: user,
            pace: state.hasSelectedPace
                ? state.pace
                : user.breathsPerMinute ?? 6,
          ),
        );
      }
    } catch (e, s) {
      addError(e, s);
      if (!isClosed) {
        emit(state.copyWith(status: ProfileStatus.failure));
      }
    }
  }

  void setPace(int pace) {
    if (!state.availablePaces.contains(pace) || state.isSavingPace) return;
    emit(state.copyWith(pace: pace, hasSelectedPace: true));
  }

  Future<void> savePace() async {
    if (state.isSavingPace || state.user == null) return;
    final pace = state.pace;
    emit(state.copyWith(isSavingPace: true, paceSaveFailed: false));
    try {
      final user = await _setUserPaceUseCase(pace);
      if (!isClosed) {
        emit(state.copyWith(user: user, isSavingPace: false));
      }
    } catch (e, s) {
      addError(e, s);
      if (!isClosed) {
        emit(state.copyWith(isSavingPace: false, paceSaveFailed: true));
      }
    }
  }
}
