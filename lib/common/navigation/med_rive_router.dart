import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/features/breath_session/pages/breath_plan_page.dart';
import 'package:med_rive/features/breath_session/pages/breath_session_page.dart';
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart';
import 'package:med_rive/features/onboarding/pages/onboarding_page.dart';
import 'package:med_rive/features/startup/pages/startup_page.dart';
import 'package:med_rive/features/startup/state/startup_cubit.dart';

part 'med_rive_router.g.dart';
part 'routes/breath_session_route.dart';
part 'routes/breath_plan_route.dart';
part 'routes/onboarding_route.dart';
part 'routes/startup_route.dart';

@lazySingleton
class MedRiveRouter {
  MedRiveRouter()
    : _goRouter = GoRouter(
        routes: $appRoutes,
        initialLocation: const StartupRoute().location,
      );

  final GoRouter _goRouter;
  GoRouter get router => _goRouter;
}
