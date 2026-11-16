import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/widgets/reset_app_dialog.dart';

class ResetAppButton extends StatelessWidget {
  const ResetAppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).resetAppTitle,
      icon: const Icon(Icons.refresh),
      onPressed: () => ResetAppDialog.show(context),
    );
  }
}
