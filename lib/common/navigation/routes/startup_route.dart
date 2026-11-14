part of '../med_rive_router.dart';

@TypedGoRoute<StartupRoute>(path: '/', name: 'StartupRoute')
class StartupRoute extends GoRouteData with $StartupRoute {
  const StartupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StartupPage();
}
