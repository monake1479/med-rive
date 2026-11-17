part of 'breath_session_cubit.dart';

enum BreathingPacesStatus { loading, ready, failure }

enum ProfileStatus { loading, ready, failure }

class BreathSessionState extends Equatable {
  const BreathSessionState({
    this.pace = 6,
    this.hasSelectedPace = false,
    this.availablePaces = const [],
    this.pacesStatus = BreathingPacesStatus.loading,
    this.status = ProfileStatus.loading,
    this.user,
    this.isSavingPace = false,
    this.paceSaveFailed = false,
  });
  final int pace;
  final bool hasSelectedPace;
  final List<int> availablePaces;
  final BreathingPacesStatus pacesStatus;
  final ProfileStatus status;
  final User? user;
  final bool isSavingPace;
  final bool paceSaveFailed;

  BreathSessionState copyWith({
    int? pace,
    bool? hasSelectedPace,
    List<int>? availablePaces,
    BreathingPacesStatus? pacesStatus,
    ProfileStatus? status,
    User? user,
    bool? isSavingPace,
    bool? paceSaveFailed,
  }) {
    return BreathSessionState(
      pace: pace ?? this.pace,
      hasSelectedPace: hasSelectedPace ?? this.hasSelectedPace,
      availablePaces: availablePaces ?? this.availablePaces,
      pacesStatus: pacesStatus ?? this.pacesStatus,
      status: status ?? this.status,
      user: user ?? this.user,
      isSavingPace: isSavingPace ?? this.isSavingPace,
      paceSaveFailed: paceSaveFailed ?? this.paceSaveFailed,
    );
  }

  @override
  List<Object?> get props => [
    pace,
    hasSelectedPace,
    status,
    user,
    isSavingPace,
    paceSaveFailed,
    availablePaces,
    pacesStatus,
  ];
}
