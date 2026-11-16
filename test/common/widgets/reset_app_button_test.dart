import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:med_rive/common/data/onboarding/use_cases/reset_app_use_case.dart';
import 'package:med_rive/common/injection/injectable.dart';
import 'package:med_rive/common/l10n/app_localizations.dart';
import 'package:med_rive/common/widgets/reset_app_button.dart';
import 'package:med_rive/features/reset_app/state/reset_app_cubit.dart';
import 'package:med_rive/features/startup/state/startup_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _Reset extends Mock implements ResetAppUseCase {}

class _Startup extends MockCubit<StartupStatus> implements StartupCubit {}

void main() {
  testWidgets('cancel does not reset; failed reset offers retry', (t) async {
    final reset = _Reset(), startup = _Startup();
    getIt.registerSingleton<ResetAppUseCase>(reset);
    getIt.registerSingleton<StartupCubit>(startup);
    getIt.registerFactory(() => ResetAppCubit(getIt<ResetAppUseCase>()));
    addTearDown(getIt.reset);
    when(reset.call).thenAnswer((_) async => throw StateError('disk'));
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(appBar: AppBar(actions: const [ResetAppButton()])),
      ),
    );
    await t.pumpAndSettle();
    await t.tap(find.byIcon(Icons.refresh));
    await t.pumpAndSettle();
    expect(
      find.text('Do you want to reset onboarding and restart the app?'),
      findsOneWidget,
    );
    await t.tap(find.text('Cancel'));
    await t.pumpAndSettle();
    verifyNever(reset.call);
    await t.tap(find.byIcon(Icons.refresh));
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(FilledButton, 'Reset'));
    await t.pumpAndSettle();
    expect(
      find.text('We couldn’t reset the app. Please try again.'),
      findsOneWidget,
    );
    verify(reset.call).called(1);
    await t.tap(find.widgetWithText(FilledButton, 'Reset'));
    await t.pumpAndSettle();
    verify(reset.call).called(1);
  });
}
