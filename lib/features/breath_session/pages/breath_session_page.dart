import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/common/widgets/reset_app_button.dart';
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart';
import 'package:med_rive/features/breath_session/widgets/phase_label.dart';

class BreathSessionPage extends StatelessWidget {
  const BreathSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocConsumer<BreathSessionCubit, BreathSessionState>(
      listenWhen: (previous, current) =>
          !previous.paceSaveFailed && current.paceSaveFailed,
      listener: (context, state) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.breathPaceSaveError))),
      builder: (context, state) {
        final breathsPerMinute = state.pace;
        final phaseSeconds = NumberFormat(
          '0.##',
          l10n.localeName,
        ).format(30 / breathsPerMinute);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IgnorePointer(
                ignoring: state.isSavingPace,
                child: const ResetAppButton(),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 24,
            title: Text(
              l10n.breathRhythmTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          body: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.breathFlowTitle,
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.breathFlowDescription,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (state.status == ProfileStatus.failure) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  l10n.breathProfileError,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                                TextButton(
                                  onPressed: context
                                      .read<BreathSessionCubit>()
                                      .loadUser,
                                  child: Text(l10n.commonRetry),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      // TODO(Daniel): Replace this SizedBox with real Rive animation.
                      SizedBox(
                        key: const ValueKey('breathing-rive-slot'),
                        height: (constraints.maxHeight - 375).clamp(
                          100.0,
                          248.0,
                        ),
                      ),
                      Text(
                        l10n.breathPreviewLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.breathPaceLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 64,
                        child: Center(
                          child: Builder(
                            builder: (context) {
                              if (state.pacesStatus ==
                                      BreathingPacesStatus.loading ||
                                  state.status == ProfileStatus.loading) {
                                return const SizedBox(
                                  height: 64,
                                  child: Center(
                                    child: SizedBox(
                                      width: 48,
                                      child: LinearProgressIndicator(),
                                    ),
                                  ),
                                );
                              }
                              if (state.pacesStatus ==
                                  BreathingPacesStatus.failure) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(l10n.breathPacesLoadError),
                                      TextButton(
                                        onPressed: context
                                            .read<BreathSessionCubit>()
                                            .loadPaces,
                                        child: Text(l10n.commonRetry),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (state.status != ProfileStatus.ready) {
                                return const SizedBox.shrink();
                              }
                              return SegmentedButton<int>(
                                expandedInsets: EdgeInsets.zero,
                                showSelectedIcon: false,
                                style: SegmentedButton.styleFrom(
                                  minimumSize: const Size(0, 32),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  textStyle: theme.textTheme.titleLarge,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                segments: [
                                  for (final pace in state.availablePaces)
                                    ButtonSegment(
                                      value: pace,
                                      label: Text('$pace'),
                                    ),
                                ],
                                selected: {breathsPerMinute},
                                onSelectionChanged: state.isSavingPace
                                    ? null
                                    : (selection) {
                                        context
                                            .read<BreathSessionCubit>()
                                            .setPace(selection.single);
                                      },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        liveRegion: true,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            PhaseLabel(
                              icon: Icons.north_east,
                              label: l10n.breathInhaleDuration(phaseSeconds),
                            ),
                            PhaseLabel(
                              icon: Icons.south_east,
                              label: l10n.breathExhaleDuration(phaseSeconds),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 56),
                        ),
                        onPressed:
                            state.status != ProfileStatus.ready ||
                                state.pacesStatus !=
                                    BreathingPacesStatus.ready ||
                                state.isSavingPace
                            ? null
                            : () {
                                final cubit = context
                                    .read<BreathSessionCubit>();
                                unawaited(cubit.savePace());
                                unawaited(
                                  BreathPlanRoute(
                                    $extra: cubit.state.user!.copyWith(
                                      breathsPerMinute: breathsPerMinute,
                                    ),
                                    pace: breathsPerMinute,
                                  ).push(context),
                                );
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.breathSeePlan),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.breathSelectionNote,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
