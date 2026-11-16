import 'package:injectable/injectable.dart';
import 'package:med_rive/common/data/breathing_pace/data_sources/breathing_pace_data_source.dart';

@lazySingleton
class BreathingPaceRepository {
  BreathingPaceRepository(this._source);
  final BreathingPaceDataSource _source;
  List<int>? _cachedPaces;

  Future<List<int>> get() async {
    final cached = _cachedPaces;
    if (cached != null) return cached;
    final paces = await _source.get();
    _cachedPaces = paces;
    return paces;
  }
}
