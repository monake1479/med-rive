part of '../med_rive_router.dart';

@TypedGoRoute<BreathPlanRoute>(path: '/breath-plan', name: 'BreathPlanRoute')
class BreathPlanRoute extends GoRouteData with $BreathPlanRoute {
  const BreathPlanRoute({required this.$extra, required this.pace});
  final User $extra;
  final int pace;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      BreathPlanPage(user: $extra, pace: pace);
}
