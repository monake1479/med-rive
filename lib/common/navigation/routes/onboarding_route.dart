part of '../med_rive_router.dart';

@TypedGoRoute<OnboardingRoute>(path: '/onboarding', name: 'OnboardingRoute')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(key: state.pageKey, child: build(context, state));

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingPage();
}
