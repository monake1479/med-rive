import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/data/user/models/user.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/widgets/reset_app_button.dart';

class BreathPlanPage extends StatelessWidget {
  const BreathPlanPage({super.key, required this.user, required this.pace});
  final User user;
  final int pace;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final seconds = NumberFormat('0.##', l10n.localeName).format(30 / pace);
    final guidance = switch (pace) {
      6 => l10n.planSlowGuidance,
      8 => l10n.planMediumGuidance,
      _ => l10n.planFasterGuidance,
    };
    return Scaffold(
      appBar: AppBar(
        actions: const [ResetAppButton()],
        centerTitle: false,
        title: Text(l10n.planAppBarTitle, style: textTheme.titleMedium),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.planGreeting(user.firstName),
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(key: ValueKey('plan-rive-slot'), height: 184),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      child: const Icon(Icons.person_outline_rounded, size: 24),
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(l10n.planAge(user.ageAt(DateTime.now()))),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: colorScheme.onPrimaryContainer),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.planSelectedPace,
                                    style: textTheme.labelMedium?.copyWith(
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.air,
                                  size: 24,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              spacing: 8,
                              children: [
                                Text(
                                  '$pace',
                                  style: textTheme.displaySmall?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                Text(l10n.planPaceUnit),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(l10n.planCycle(seconds)),
                            const SizedBox(height: 8),
                            Text(
                              guidance,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.planAdjust),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.planNote,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
