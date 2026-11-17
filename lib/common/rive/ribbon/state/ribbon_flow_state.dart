import 'package:equatable/equatable.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';

enum RibbonLoadStatus { initial, loading, ready, failure }

class RibbonFlowState extends Equatable {
  const RibbonFlowState({
    this.loadStatus = RibbonLoadStatus.initial,
    this.requestedStage = RibbonStage.startup,
    this.visibleStage = RibbonStage.startup,
    this.isTransitioning = true,
    this.activeBreathsPerMinute = 0,
    this.controllerRevision = 0,
  });

  final RibbonLoadStatus loadStatus;
  final RibbonStage requestedStage;
  final RibbonStage visibleStage;
  final bool isTransitioning;
  final int activeBreathsPerMinute;
  final int controllerRevision;

  RibbonFlowState copyWith({
    RibbonLoadStatus? loadStatus,
    RibbonStage? requestedStage,
    RibbonStage? visibleStage,
    bool? isTransitioning,
    int? activeBreathsPerMinute,
    int? controllerRevision,
  }) => RibbonFlowState(
    loadStatus: loadStatus ?? this.loadStatus,
    requestedStage: requestedStage ?? this.requestedStage,
    visibleStage: visibleStage ?? this.visibleStage,
    isTransitioning: isTransitioning ?? this.isTransitioning,
    activeBreathsPerMinute:
        activeBreathsPerMinute ?? this.activeBreathsPerMinute,
    controllerRevision: controllerRevision ?? this.controllerRevision,
  );

  @override
  List<Object?> get props => [
    loadStatus,
    requestedStage,
    visibleStage,
    isTransitioning,
    activeBreathsPerMinute,
    controllerRevision,
  ];
}
