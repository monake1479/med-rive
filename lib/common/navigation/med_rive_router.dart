import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/features/breath_session/pages/breath_session_page.dart';
import 'package:med_rive/features/onboarding/pages/onboarding_page.dart';

part 'med_rive_router.g.dart';
part './routes/main_route.dart';
part './routes/onboarding_route.dart';

@lazySingleton
class MedRiveRouter {
  MedRiveRouter()
    : _goRouter = GoRouter(
        routes: $appRoutes,
        initialLocation: const OnboardingRoute().location,
      );

  final GoRouter _goRouter;
  GoRouter get router => _goRouter;
}
