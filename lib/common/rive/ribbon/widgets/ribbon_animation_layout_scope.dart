import 'package:flutter/widgets.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';

class RibbonAnimationLayoutScope extends InheritedWidget {
  const RibbonAnimationLayoutScope({
    required this.registerTarget,
    required this.unregisterTarget,
    required super.child,
    super.key,
  });

  final void Function(RibbonStage stage, GlobalKey anchorKey) registerTarget;
  final void Function(RibbonStage stage, GlobalKey anchorKey) unregisterTarget;

  static RibbonAnimationLayoutScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<RibbonAnimationLayoutScope>();
    assert(scope != null, 'RibbonAnimationTarget requires RibbonFlowShell.');
    return scope!;
  }

  @override
  bool updateShouldNotify(RibbonAnimationLayoutScope oldWidget) =>
      registerTarget != oldWidget.registerTarget ||
      unregisterTarget != oldWidget.unregisterTarget;
}
