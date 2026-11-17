part of '../med_rive_router.dart';

@TypedGoRoute<StartupRoute>(path: '/', name: 'StartupRoute')
class StartupRoute extends GoRouteData with $StartupRoute {
  const StartupRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(key: state.pageKey, child: build(context, state));

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (context) => getIt.get<StartupCubit>(),
    child: const StartupPage(),
  );
}
