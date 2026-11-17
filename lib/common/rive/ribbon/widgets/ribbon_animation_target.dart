import 'package:flutter/widgets.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/widgets/ribbon_animation_layout_scope.dart';

class RibbonAnimationTarget extends StatefulWidget {
  const RibbonAnimationTarget({
    required this.stage,
    required this.child,
    super.key,
  });

  final RibbonStage stage;
  final Widget child;

  @override
  State<RibbonAnimationTarget> createState() => _RibbonAnimationTargetState();
}

class _RibbonAnimationTargetState extends State<RibbonAnimationTarget> {
  final _targetAnchorKey = GlobalKey();
  RibbonAnimationLayoutScope? _layoutScope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final layoutScope = RibbonAnimationLayoutScope.of(context);
    if (!identical(layoutScope, _layoutScope)) {
      _layoutScope?.unregisterTarget(widget.stage, _targetAnchorKey);
      _layoutScope = layoutScope;
    }
  }

  @override
  void didUpdateWidget(RibbonAnimationTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stage != oldWidget.stage) {
      _layoutScope?.unregisterTarget(oldWidget.stage, _targetAnchorKey);
    }
  }

  @override
  void dispose() {
    _layoutScope?.unregisterTarget(widget.stage, _targetAnchorKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _layoutScope?.registerTarget(widget.stage, _targetAnchorKey);
        }
      });
      return SizedBox(key: _targetAnchorKey, child: widget.child);
    },
  );
}
