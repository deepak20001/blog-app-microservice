// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart'
    as _i190;
import 'package:blog_client/core/services/network_service/dio_client.dart'
    as _i647;
import 'package:blog_client/core/utils/debouncer.dart' as _i942;
import 'package:blog_client/features/auth/repositories/auth_remote_repository.dart'
    as _i509;
import 'package:blog_client/features/auth/viewmodel/auth_bloc.dart' as _i876;
import 'package:blog_client/features/blogs/repositories/blogs_remote_repository.dart'
    as _i658;
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart' as _i942;
import 'package:blog_client/injection_container.dart' as _i634;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i942.Debouncer<dynamic>>(() => registerModule.debouncer);
    gh.lazySingleton<_i190.SharedPreferencesStorageRepository>(
      () => _i190.SharedPreferencesStorageRepositoryImpl(
        prefs: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i647.DioClient>(
      () => _i647.DioClient(
        dio: gh<_i361.Dio>(),
        storageRepository: gh<_i190.SharedPreferencesStorageRepository>(),
      ),
    );
    gh.lazySingleton<_i509.AuthRemoteRepository>(
      () => _i509.AuthRemoteRepositoryImpl(dioClient: gh<_i647.DioClient>()),
    );
    gh.lazySingleton<_i658.BlogsRemoteRepository>(
      () => _i658.BlogsRemoteRepositoryImpl(dioClient: gh<_i647.DioClient>()),
    );
    gh.singleton<_i876.AuthBloc>(
      () => _i876.AuthBloc(
        authRemoteRepository: gh<_i509.AuthRemoteRepository>(),
        storageRepository: gh<_i190.SharedPreferencesStorageRepository>(),
      ),
    );
    gh.singleton<_i942.BlogsBloc>(
      () => _i942.BlogsBloc(
        blogsRemoteRepository: gh<_i658.BlogsRemoteRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i634.RegisterModule {}
