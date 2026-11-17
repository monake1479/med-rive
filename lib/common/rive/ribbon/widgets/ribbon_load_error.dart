import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart';
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_state.dart';

class RibbonLoadError extends StatelessWidget {
  const RibbonLoadError({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocSelector<RibbonFlowCubit, RibbonFlowState, RibbonLoadStatus>(
    selector: (state) => state.loadStatus,
    builder: (context, status) {
      if (status != RibbonLoadStatus.failure) return const SizedBox.shrink();
      final l10n = AppLocalizations.of(context);
      return Positioned(
        left: 16,
        right: 16,
        bottom: 16 + MediaQuery.paddingOf(context).bottom,
        child: Material(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(child: Text(l10n.ribbonLoadError)),
                TextButton(
                  onPressed: context.read<RibbonFlowCubit>().initialize,
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
