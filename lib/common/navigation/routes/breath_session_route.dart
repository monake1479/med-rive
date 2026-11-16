part of '../med_rive_router.dart';

@TypedGoRoute<BreathSessionRoute>(
  path: '/breath-session',
  name: 'BreathSessionRoute',
)
class BreathSessionRoute extends GoRouteData with $BreathSessionRoute {
  const BreathSessionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (_) => getIt<BreathSessionCubit>(),
    child: const BreathSessionPage(),
  );
}
