import 'dart:developer';

import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';

class BreathSessionPage extends StatelessWidget {
  const BreathSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('[BreathSessionPage] build');

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.breathSessionPageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [Text(l10n.commonPlaceholder)],
        ),
      ),
    );
  }
}
