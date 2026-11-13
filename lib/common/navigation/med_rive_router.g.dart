// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_rive_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$onboardingRoute];

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  name: 'OnboardingRoute',
  hasOverriddenOnExit: false,
  factory: $OnboardingRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'breath-session',
      hasOverriddenOnExit: false,
      factory: $BreathSessionRoute._fromState,
    ),
  ],
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BreathSessionRoute on GoRouteData {
  static BreathSessionRoute _fromState(GoRouterState state) =>
      const BreathSessionRoute();

  @override
  String get location => GoRouteData.$location('/onboarding/breath-session');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
