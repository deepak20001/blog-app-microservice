import 'package:blog_client/core/routes/app_routes.dart';
import 'package:blog_client/core/utils/debouncer.dart';
import 'package:blog_client/injection_container.config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();

  // Register AppRouter manually
  getIt.registerLazySingleton<AppRouter>(AppRouter.new);
}

// Register external dependencies that need special setup
@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  Debouncer<dynamic> get debouncer => Debouncer<dynamic>();
}
