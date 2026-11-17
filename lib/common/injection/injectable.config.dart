// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:med_rive/common/data/breathing_pace/breathing_pace_repository.dart'
    as _i416;
import 'package:med_rive/common/data/breathing_pace/data_sources/breathing_pace_data_source.dart'
    as _i568;
import 'package:med_rive/common/data/breathing_pace/use_cases/get_breathing_paces_use_case.dart'
    as _i161;
import 'package:med_rive/common/data/onboarding/data_sources/onboarding_local_data_source.dart'
    as _i534;
import 'package:med_rive/common/data/onboarding/onboarding_repository.dart'
    as _i960;
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart'
    as _i619;
import 'package:med_rive/common/data/onboarding/use_cases/reset_app_use_case.dart'
    as _i164;
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart'
    as _i323;
import 'package:med_rive/common/data/user/data_sources/user_remote_data_source.dart'
    as _i291;
import 'package:med_rive/common/data/user/use_cases/get_user_use_case.dart'
    as _i391;
import 'package:med_rive/common/data/user/use_cases/set_user_pace_use_case.dart'
    as _i589;
import 'package:med_rive/common/data/user/user_repository.dart' as _i873;
import 'package:med_rive/common/injection/storage_module.dart' as _i548;
import 'package:med_rive/common/navigation/med_rive_router.dart' as _i393;
import 'package:med_rive/common/rive/ribbon/rive_ribbon_playback.dart' as _i289;
import 'package:med_rive/common/rive/ribbon/state/ribbon_flow_cubit.dart'
    as _i254;
import 'package:med_rive/common/rive/shared/rive_asset_player.dart' as _i109;
import 'package:med_rive/features/breath_session/state/breath_session_cubit.dart'
    as _i591;
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart'
    as _i129;
import 'package:med_rive/features/reset_app/state/reset_app_cubit.dart'
    as _i773;
import 'package:med_rive/features/startup/state/startup_cubit.dart' as _i263;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    gh.factory<_i109.RiveAssetPlayer>(() => _i109.RiveAssetPlayer());
    gh.lazySingleton<_i568.BreathingPaceDataSource>(
      () => _i568.BreathingPaceDataSource(),
    );
    gh.lazySingleton<_i460.SharedPreferencesAsync>(
      () => storageModule.preferences,
    );
    gh.lazySingleton<_i393.MedRiveRouter>(() => _i393.MedRiveRouter());
    gh.lazySingleton<_i534.OnboardingLocalDataSource>(
      () => _i534.OnboardingLocalDataSource(gh<_i460.SharedPreferencesAsync>()),
    );
    gh.lazySingleton<_i291.UserRemoteDataSource>(
      () => _i291.UserRemoteDataSource(gh<_i460.SharedPreferencesAsync>()),
    );
    gh.lazySingleton<_i960.OnboardingRepository>(
      () => _i960.OnboardingRepository(gh<_i534.OnboardingLocalDataSource>()),
    );
    gh.factory<_i619.GetOnboardingStatusUseCase>(
      () => _i619.GetOnboardingStatusUseCase(gh<_i960.OnboardingRepository>()),
    );
    gh.factory<_i323.SetOnboardingStatusUseCase>(
      () => _i323.SetOnboardingStatusUseCase(gh<_i960.OnboardingRepository>()),
    );
    gh.lazySingleton<_i129.OnboardingBloc>(
      () => _i129.OnboardingBloc(
        getOnboardingStatusUseCase: gh<_i619.GetOnboardingStatusUseCase>(),
        setOnboardingStatusUseCase: gh<_i323.SetOnboardingStatusUseCase>(),
      ),
    );
    gh.lazySingleton<_i873.UserRepository>(
      () => _i873.UserRepository(gh<_i291.UserRemoteDataSource>()),
    );
    gh.lazySingleton<_i416.BreathingPaceRepository>(
      () => _i416.BreathingPaceRepository(gh<_i568.BreathingPaceDataSource>()),
    );
    gh.factory<_i391.GetUserUseCase>(
      () => _i391.GetUserUseCase(gh<_i873.UserRepository>()),
    );
    gh.factory<_i589.SetUserPaceUseCase>(
      () => _i589.SetUserPaceUseCase(gh<_i873.UserRepository>()),
    );
    gh.factory<_i263.StartupCubit>(
      () => _i263.StartupCubit(gh<_i619.GetOnboardingStatusUseCase>()),
    );
    gh.factory<_i289.RiveRibbonPlayback>(
      () => _i289.RiveRibbonPlayback(gh<_i109.RiveAssetPlayer>()),
    );
    gh.factory<_i161.GetBreathingPacesUseCase>(
      () => _i161.GetBreathingPacesUseCase(gh<_i416.BreathingPaceRepository>()),
    );
    gh.factory<_i254.RibbonFlowCubit>(
      () => _i254.RibbonFlowCubit(gh<_i289.RiveRibbonPlayback>()),
    );
    gh.factory<_i591.BreathSessionCubit>(
      () => _i591.BreathSessionCubit(
        gh<_i391.GetUserUseCase>(),
        gh<_i589.SetUserPaceUseCase>(),
        gh<_i161.GetBreathingPacesUseCase>(),
      ),
    );
    gh.factory<_i164.ResetAppUseCase>(
      () => _i164.ResetAppUseCase(
        gh<_i323.SetOnboardingStatusUseCase>(),
        gh<_i873.UserRepository>(),
      ),
    );
    gh.factory<_i773.ResetAppCubit>(
      () => _i773.ResetAppCubit(gh<_i164.ResetAppUseCase>()),
    );
    return this;
  }
}

class _$StorageModule extends _i548.StorageModule {}
