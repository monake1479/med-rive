import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:med_rive/med_rive_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final onboardingBloc = getIt<OnboardingBloc>()
    ..add(const OnboardingStarted());
  runApp(BlocProvider.value(value: onboardingBloc, child: const MedRiveApp()));
}
