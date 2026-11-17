import 'package:flutter/foundation.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/scenes/ribbon_scenes.dart';
import 'package:rive/rive.dart' as rive;

class RibbonBindings {
  factory RibbonBindings(
    rive.RiveWidgetController controller, {
    required VoidCallback onChanged,
  }) {
    final bindings = RibbonBindings._(onChanged);
    try {
      bindings._attach(controller);
      return bindings;
    } catch (_) {
      bindings.dispose();
      rethrow;
    }
  }

  RibbonBindings._(this._onBindingsChanged);

  final VoidCallback _onBindingsChanged;
  rive.ViewModelInstance? _viewModelInstance;
  rive.ViewModelInstanceNumber? _requestedStageProperty;
  rive.ViewModelInstanceNumber? _requestedPaceProperty;
  rive.ViewModelInstanceNumber? _contentStepProperty;
  rive.ViewModelInstanceNumber? _activePaceProperty;
  rive.ViewModelInstanceBoolean? _isTransitioningProperty;

  RibbonStage get visibleStage =>
      ribbonStageFromContentStep(_contentStepProperty!.value.round());
  int get activeBreathsPerMinute => _activePaceProperty!.value.round();
  bool get isTransitioning => _isTransitioningProperty!.value;

  void _attach(rive.RiveWidgetController controller) {
    final viewModelInstance = _viewModelInstance = controller.dataBind(
      rive.DataBind.auto(),
    );
    _requestedStageProperty = viewModelInstance.number('scene');
    _requestedPaceProperty = viewModelInstance.number('pace');
    _contentStepProperty = viewModelInstance.number('contentStep');
    _activePaceProperty = viewModelInstance.number('activePace');
    _isTransitioningProperty = viewModelInstance.boolean('transitioning');
    if (_requestedStageProperty == null ||
        _requestedPaceProperty == null ||
        _contentStepProperty == null ||
        _activePaceProperty == null ||
        _isTransitioningProperty == null) {
      throw StateError(
        'The ribbon export does not match its binding contract.',
      );
    }
    _contentStepProperty!.addListener(_onNumberChanged);
    _activePaceProperty!.addListener(_onNumberChanged);
    _isTransitioningProperty!.addListener(_onBooleanChanged);
  }

  void _onNumberChanged(double _) => _onBindingsChanged();
  void _onBooleanChanged(bool _) => _onBindingsChanged();

  void requestStage(RibbonStage stage) {
    _requestedStageProperty!.value = stage.configuration.inputValue.toDouble();
  }

  void setBreathingPace(int breathsPerMinute) {
    _requestedPaceProperty!.value = breathsPerMinute.toDouble();
  }

  void dispose() {
    _contentStepProperty?.removeListener(_onNumberChanged);
    _activePaceProperty?.removeListener(_onNumberChanged);
    _isTransitioningProperty?.removeListener(_onBooleanChanged);
    _requestedStageProperty?.dispose();
    _requestedPaceProperty?.dispose();
    _contentStepProperty?.dispose();
    _activePaceProperty?.dispose();
    _isTransitioningProperty?.dispose();
    _viewModelInstance?.dispose();
  }
}
