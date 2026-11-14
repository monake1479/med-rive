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
import 'package:med_rive/common/data/onboarding/data_sources/onboarding_local_data_source.dart'
    as _i534;
import 'package:med_rive/common/data/onboarding/onboarding_repository.dart'
    as _i960;
import 'package:med_rive/common/data/onboarding/use_cases/get_onboarding_status_use_case.dart'
    as _i619;
import 'package:med_rive/common/data/onboarding/use_cases/set_onboarding_status_use_case.dart'
    as _i323;
import 'package:med_rive/common/injection/storage_module.dart' as _i548;
import 'package:med_rive/common/navigation/med_rive_router.dart' as _i393;
import 'package:med_rive/features/onboarding/state/onboarding/onboarding_bloc.dart'
    as _i129;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    gh.lazySingleton<_i460.SharedPreferencesAsync>(
      () => storageModule.preferences,
    );
    gh.lazySingleton<_i393.MedRiveRouter>(() => _i393.MedRiveRouter());
    gh.lazySingleton<_i534.OnboardingLocalDataSource>(
      () => _i534.OnboardingLocalDataSource(gh<_i460.SharedPreferencesAsync>()),
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
    return this;
  }
}

class _$StorageModule extends _i548.StorageModule {}
