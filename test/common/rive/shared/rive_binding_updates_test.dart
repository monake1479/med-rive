import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:med_rive/common/rive/shared/rive_binding_updates.dart';

void main() {
  testWidgets('multiple binding changes notify once after the frame', (
    tester,
  ) async {
    final updates = RiveBindingUpdates();
    var notifications = 0;
    final subscription = updates.stream.listen((_) => notifications++);
    updates.schedule();
    updates.schedule();
    updates.schedule();
    expect(notifications, 0);
    await tester.pumpWidget(const SizedBox());
    expect(notifications, 1);
    unawaited(subscription.cancel());
    final closing = updates.close();
    await tester.pump();
    await closing;
  });

  testWidgets('closing drops a previously scheduled binding notification', (
    tester,
  ) async {
    final updates = RiveBindingUpdates();
    var notifications = 0;
    updates.stream.listen((_) => notifications++);
    updates.schedule();
    final closing = updates.close();
    await tester.pump();
    await closing;
    expect(notifications, 0);
    expect(tester.takeException(), isNull);
  });
}
