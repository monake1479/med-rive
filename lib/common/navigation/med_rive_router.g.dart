// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_rive_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $breathSessionRoute,
  $breathPlanRoute,
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

RouteBase get $breathPlanRoute => GoRouteData.$route(
  path: '/breath-plan',
  name: 'BreathPlanRoute',
  hasOverriddenOnExit: false,
  factory: $BreathPlanRoute._fromState,
);

mixin $BreathPlanRoute on GoRouteData {
  static BreathPlanRoute _fromState(GoRouterState state) => BreathPlanRoute(
    pace: int.parse(state.uri.queryParameters['pace']!),
    $extra: state.extra as User,
  );

  BreathPlanRoute get _self => this as BreathPlanRoute;

  @override
  String get location => GoRouteData.$location(
    '/breath-plan',
    queryParams: {'pace': _self.pace.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
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
