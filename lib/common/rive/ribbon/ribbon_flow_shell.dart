import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_state.dart';
import 'package:med_rive/common/rive/ribbon/widgets/ribbon_animation_layout_scope.dart';
import 'package:med_rive/common/rive/ribbon/widgets/ribbon_canvas.dart';
import 'package:med_rive/common/rive/ribbon/widgets/ribbon_load_error.dart';
import 'package:med_rive/common/rive/ribbon/widgets/ribbon_page_content.dart';

class RibbonFlowShell extends StatelessWidget {
  const RibbonFlowShell({
    required this.entryStage,
    required this.child,
    super.key,
  });

  final RibbonStage entryStage;
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<RibbonFlowCubit>()..initialize(),
    child: _RibbonFlowView(entryStage: entryStage, child: child),
  );
}

class _RibbonFlowView extends StatefulWidget {
  const _RibbonFlowView({required this.entryStage, required this.child});

  final RibbonStage entryStage;
  final Widget child;

  @override
  State<_RibbonFlowView> createState() => _RibbonFlowViewState();
}

class _RibbonFlowViewState extends State<_RibbonFlowView> {
  final Map<RibbonStage, List<GlobalKey>> _targetAnchorsByStage = {};
  Rect? _ribbonLandingRect;

  @override
  void initState() {
    super.initState();
    if (widget.entryStage != RibbonStage.startup) {
      unawaited(context.read<RibbonFlowCubit>().showStage(widget.entryStage));
    }
  }

  @override
  void didUpdateWidget(_RibbonFlowView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entryStage == RibbonStage.startup &&
        oldWidget.entryStage != RibbonStage.startup) {
      context.read<RibbonFlowCubit>().restart();
    }
  }

  void _registerTarget(RibbonStage stage, GlobalKey anchorKey) {
    final stageAnchors = _targetAnchorsByStage.putIfAbsent(stage, () => []);
    if (!stageAnchors.contains(anchorKey)) stageAnchors.add(anchorKey);
    _updateRibbonLandingRect();
  }

  void _unregisterTarget(RibbonStage stage, GlobalKey anchorKey) {
    _targetAnchorsByStage[stage]?.remove(anchorKey);
    _scheduleLayoutMeasurement();
  }

  void _scheduleLayoutMeasurement() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateRibbonLandingRect(),
    );
  }

  void _updateRibbonLandingRect() {
    if (!mounted) return;
    final stage = context.read<RibbonFlowCubit>().state.visibleStage;
    final anchorKey = _targetAnchorsByStage[stage]?.lastOrNull;
    final renderObject = anchorKey?.currentContext?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return;
    }
    final landingRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    if (landingRect == _ribbonLandingRect) return;
    setState(() => _ribbonLandingRect = landingRect);
  }

  @override
  Widget build(BuildContext context) => RibbonAnimationLayoutScope(
    registerTarget: _registerTarget,
    unregisterTarget: _unregisterTarget,
    child: BlocListener<RibbonFlowCubit, RibbonFlowState>(
      listenWhen: (previous, current) =>
          previous.visibleStage != current.visibleStage,
      listener: (context, state) => _updateRibbonLandingRect(),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: RibbonCanvas(landingRect: _ribbonLandingRect),
            ),
            RibbonPageContent(
              onScroll: _scheduleLayoutMeasurement,
              child: widget.child,
            ),
            const RibbonLoadError(),
          ],
        ),
      ),
    ),
  );
}
