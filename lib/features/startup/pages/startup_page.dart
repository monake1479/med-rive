import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/common/rive/ribbon/widgets/ribbon_animation_target.dart';
import 'package:med_rive/features/startup/state/startup_cubit.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    context.read<StartupCubit>().start();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<StartupCubit, StartupStatus>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          final ribbonFlowCubit = context.read<RibbonFlowCubit>();
          if (state.isInOnboarding) {
            await ribbonFlowCubit.showStage(RibbonStage.welcome);
            if (!context.mounted) return;
            const OnboardingRoute().go(context);
          } else if (state.isReady) {
            await ribbonFlowCubit.showStage(RibbonStage.plan);
            if (!context.mounted) return;
            const BreathSessionRoute().go(context);
          }
        },
        builder: (context, state) {
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
                                  const RibbonAnimationTarget(
                                    stage: RibbonStage.startup,
                                    child: SizedBox(
                                      key: ValueKey('startup-rive-slot'),
                                      height: 280,
                                      width: double.infinity,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    l10n.appName,
                                    style: theme.textTheme.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    state.isFailure
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
                                      if (state.isFailure) {
                                        return FilledButton(
                                          onPressed: () => context
                                              .read<StartupCubit>()
                                              .start(),
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
