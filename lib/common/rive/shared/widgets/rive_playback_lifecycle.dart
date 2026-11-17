import 'package:flutter/widgets.dart';

class RivePlaybackLifecycle extends StatefulWidget {
  const RivePlaybackLifecycle({
    required this.onActivityChanged,
    required this.child,
    super.key,
  });

  final ValueChanged<bool> onActivityChanged;
  final Widget child;

  @override
  State<RivePlaybackLifecycle> createState() => _RivePlaybackLifecycleState();
}

class _RivePlaybackLifecycleState extends State<RivePlaybackLifecycle>
    with WidgetsBindingObserver {
  bool _isAppResumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    _isAppResumed =
        lifecycleState == null || lifecycleState == AppLifecycleState.resumed;
    _notifyPlaybackActivity();
  }

  @override
  void didUpdateWidget(RivePlaybackLifecycle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onActivityChanged != oldWidget.onActivityChanged) {
      _notifyPlaybackActivity();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppResumed = state == AppLifecycleState.resumed;
    _notifyPlaybackActivity();
  }

  void _notifyPlaybackActivity() => widget.onActivityChanged(_isAppResumed);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
