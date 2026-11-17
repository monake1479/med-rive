import 'dart:async';

import 'package:flutter/scheduler.dart';

class RiveBindingUpdates {
  final _updatesController = StreamController<void>.broadcast();
  bool _isClosed = false;
  bool _isNotificationScheduled = false;

  Stream<void> get stream => _updatesController.stream;

  void schedule() {
    if (_isClosed || _isNotificationScheduled) return;
    _isNotificationScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _isNotificationScheduled = false;
      if (!_isClosed) _updatesController.add(null);
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  Future<void> close() async {
    _isClosed = true;
    await _updatesController.close();
  }
}
