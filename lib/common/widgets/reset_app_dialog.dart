import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/navigation/med_rive_router.dart';
import 'package:med_rive/features/reset_app/state/reset_app_cubit.dart';

class ResetAppDialog extends StatelessWidget {
  const ResetAppDialog._();

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ResetAppCubit>(),
        child: const ResetAppDialog._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<ResetAppCubit, ResetAppStatus>(
      listener: (context, status) {
        if (status == ResetAppStatus.success) {
          Navigator.of(context).pop();
          StartupRoute().go(context);
        }
      },
      builder: (context, status) {
        final resetInProgress = status == ResetAppStatus.inProgress;
        return PopScope(
          canPop: !resetInProgress,
          child: AlertDialog(
            title: Text(l10n.resetAppTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.resetAppQuestion),
                const SizedBox(height: 12),
                Text(l10n.resetAppDescription),
                if (resetInProgress) ...[
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                ],
                if (status == ResetAppStatus.failure) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.resetAppError,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: resetInProgress
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: resetInProgress
                    ? null
                    : context.read<ResetAppCubit>().reset,
                child: Text(l10n.resetAppConfirm),
              ),
            ],
          ),
        );
      },
    );
  }
}
