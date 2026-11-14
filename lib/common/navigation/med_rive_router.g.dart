// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_rive_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $breathSessionRoute,
  $onboardingRoute,
  $startupRoute,
];

RouteBase get $breathSessionRoute => GoRouteData.$route(
  path: '/breath-session',
  name: 'BreathSessionRoute',
  hasOverriddenOnExit: false,
  factory: $BreathSessionRoute._fromState,
);

mixin $BreathSessionRoute on GoRouteData {
  static BreathSessionRoute _fromState(GoRouterState state) =>
      const BreathSessionRoute();

  @override
  String get location => GoRouteData.$location('/breath-session');

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

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  name: 'OnboardingRoute',
  hasOverriddenOnExit: false,
  factory: $OnboardingRoute._fromState,
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

RouteBase get $startupRoute => GoRouteData.$route(
  path: '/',
  name: 'StartupRoute',
  hasOverriddenOnExit: false,
  factory: $StartupRoute._fromState,
);

mixin $StartupRoute on GoRouteData {
  static StartupRoute _fromState(GoRouterState state) => const StartupRoute();

  @override
  String get location => GoRouteData.$location('/');

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
