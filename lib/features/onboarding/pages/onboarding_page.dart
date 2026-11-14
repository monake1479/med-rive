import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.onboardingPageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            BlocListener<OnboardingBloc, OnboardingState>(
              listenWhen: (previous, current) {
                return previous.status != current.status;
              },
              listener: (context, state) {
                if (state.status.isCompleted) {
                  BreathSessionRoute().go(context);
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(SetOnboarding(true));
                },
                child: BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return Text(
                      state.status.isLoading
                          ? l10n.commonLoading
                          : l10n.onboardButtonLabel,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
