import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/common/rive/ribbon/ribbon_stage.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart';
import 'package:med_rive/features/onboarding/widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _page = 0;
  bool _moving = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showPage(int page) async {
    if (_moving) return;
    setState(() => _moving = true);
    await context.read<RibbonFlowCubit>().showStage(
      page == 0 ? RibbonStage.welcome : RibbonStage.rhythm,
    );
    if (!mounted) return;
    _pageController.jumpToPage(page);
    setState(() => _moving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (state.status.isCompleted) {
          await context.read<RibbonFlowCubit>().showStage(RibbonStage.plan);
          if (!context.mounted) return;
          const BreathSessionRoute().go(context);
        }
      },
      builder: (context, state) {
        final busy =
            state.status.isLoading ||
            _moving ||
            context.watch<RibbonFlowCubit>().state.isTransitioning;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 12,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28,
                  height: 48,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: _page == 0
                        ? Icon(
                            Icons.air,
                            key: const ValueKey('air'),
                            size: 28,
                            color: theme.colorScheme.primary,
                          )
                        : SizedBox(
                            key: const ValueKey('back'),
                            width: 28,
                            height: 48,
                            child: OverflowBox(
                              minWidth: 48,
                              maxWidth: 48,
                              child: BackButton(
                                color: theme.colorScheme.primary,
                                onPressed: () {
                                  if (!busy) _showPage(0);
                                },
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(l10n.appName, style: theme.textTheme.titleLarge),
              ],
            ),
          ),
          body: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (page) => setState(() => _page = page),
                        children: [
                          OnboardingSlide(
                            stage: RibbonStage.welcome,
                            upperTitle: l10n.onboardingWelcomeUpperTitle,
                            title: l10n.onboardingWelcomeTitle,
                            description: l10n.onboardingWelcomeDescription,
                          ),
                          OnboardingSlide(
                            stage: RibbonStage.rhythm,
                            upperTitle: l10n.onboardingRhythmUpperTitle,
                            title: l10n.onboardingRhythmTitle,
                            description: l10n.onboardingRhythmDescription,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Semantics(
                            label: l10n.onboardingPageIndicator(_page + 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                2,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: index == _page ? 24 : 8,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: index == _page
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outlineVariant,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              if (state.status == OnboardingStatus.failure) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Semantics(
                                    liveRegion: true,
                                    child: Text(
                                      l10n.onboardingSaveError,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.error,
                                          ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 56),
                              ),
                              onPressed: busy
                                  ? null
                                  : () {
                                      if (_page == 0) {
                                        _showPage(1);
                                      } else {
                                        context.read<OnboardingBloc>().add(
                                          const SetOnboarding(true),
                                        );
                                      }
                                    },
                              child: Text(
                                state.status.isLoading
                                    ? l10n.commonLoading
                                    : _page == 0
                                    ? l10n.onboardButtonLabel
                                    : l10n.onboardingFinishLabel,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
