import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/breathing_pace/breathing_pace_repository.dart';

@injectable
class GetBreathingPacesUseCase {
  const GetBreathingPacesUseCase(this._repository);
  final BreathingPaceRepository _repository;
  Future<List<int>> call() => _repository.get();
}
