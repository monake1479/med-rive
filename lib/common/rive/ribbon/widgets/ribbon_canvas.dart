import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_rive/common/rive/ribbon/scenes/ribbon_scenes.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_state.dart';
import 'package:med_rive/common/rive/shared/widgets/rive_canvas.dart';
import 'package:med_rive/common/rive/shared/widgets/rive_playback_lifecycle.dart';

class RibbonCanvas extends StatelessWidget {
  const RibbonCanvas({required this.landingRect, super.key});

  final Rect? landingRect;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RibbonFlowCubit, RibbonFlowState>(
        builder: (context, state) {
          final controller = context.read<RibbonFlowCubit>().riveController;
          return RivePlaybackLifecycle(
            onActivityChanged: (isActive) => controller?.active = isActive,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (controller == null) return const SizedBox.shrink();
                final targetRect =
                    landingRect ??
                    Rect.fromLTWH(
                      24,
                      constraints.maxHeight * .25,
                      constraints.maxWidth - 48,
                      240,
                    );
                return IgnorePointer(
                  child: ExcludeSemantics(
                    child: RiveCanvas(
                      controller: controller,
                      layout: state.visibleStage.configuration.layout,
                      targetRect: targetRect,
                      layoutAnimationDuration: state.isTransitioning
                          ? Duration.zero
                          : const Duration(milliseconds: 300),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
}
