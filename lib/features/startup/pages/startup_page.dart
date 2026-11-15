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
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isInProgress) {
            const OnboardingRoute().go(context);
          } else if (state.status.isCompleted) {
            const BreathSessionRoute().go(context);
          }
        },
        builder: (context, state) {
          final failed = state.status == OnboardingStatus.failure;

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      children: [
                        SizedBox(
                          height: (constraints.maxHeight - 72).clamp(
                            480.0,
                            double.infinity,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // TODO(Daniel): Replace this SizedBox with real Rive animation.
                                  const SizedBox(
                                    key: ValueKey('startup-rive-slot'),
                                    height: 280,
                                    width: double.infinity,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    l10n.appName,
                                    style: theme.textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    failed
                                        ? l10n.startupLoadingError
                                        : l10n.startupLoadingMessage,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 24),
                                  Builder(
                                    builder: (context) {
                                      if (failed) {
                                        return FilledButton(
                                          onPressed: () => context
                                              .read<OnboardingBloc>()
                                              .add(const OnboardingStarted()),
                                          child: Text(l10n.commonRetry),
                                        );
                                      }
                                      return const SizedBox(
                                        width: 48,
                                        child: LinearProgressIndicator(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.startupFooter,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
