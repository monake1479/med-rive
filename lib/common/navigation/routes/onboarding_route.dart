part of '../med_rive_router.dart';

@TypedGoRoute<OnboardingRoute>(path: '/onboarding', name: 'OnboardingRoute')
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingPage();
}
