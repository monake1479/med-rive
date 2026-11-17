import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';

class RibbonBreathingPace extends StatefulWidget {
  const RibbonBreathingPace({
    required this.breathsPerMinute,
    required this.child,
    super.key,
  });

  final int breathsPerMinute;
  final Widget child;

  @override
  State<RibbonBreathingPace> createState() => _RibbonBreathingPaceState();
}

class _RibbonBreathingPaceState extends State<RibbonBreathingPace> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _synchronizePace();
  }

  @override
  void didUpdateWidget(RibbonBreathingPace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breathsPerMinute != oldWidget.breathsPerMinute) {
      _synchronizePace();
    }
  }

  void _synchronizePace() {
    context.read<RibbonFlowCubit>().setBreathingPace(widget.breathsPerMinute);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
