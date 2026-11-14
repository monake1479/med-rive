import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.startupPageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            BlocConsumer<OnboardingBloc, OnboardingState>(
              listenWhen: (previous, current) {
                return previous.status != current.status;
              },
              listener: (context, state) async {
                if (state.status.isInProgress) {
                  const OnboardingRoute().go(context);
                } else if (state.status.isCompleted) {
                  const BreathSessionRoute().go(context);
                }
              },
              builder: (context, state) {
                // TODO(Daniel): Texts below will be replaced soon with AppLocalizations.
                switch (state.status) {
                  case OnboardingStatus.initial:
                    return Text('Initial');
                  case OnboardingStatus.loading:
                    return Text(AppLocalizations.of(context).commonLoading);
                  case OnboardingStatus.completed:
                    return Text('Completed');
                  case OnboardingStatus.inProgress:
                    return Text('In progress, should be redirected');
                  case OnboardingStatus.failure:
                    final exception = state.exception;
                    return Text('Failure! Exception: $exception');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
