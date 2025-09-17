import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.dart';
import 'package:blog_client/core/theme/theme.dart';
import 'package:blog_client/core/utils/simple_bloc_observer.dart';
import 'package:blog_client/features/auth/viewmodel/auth_bloc.dart';
import 'package:blog_client/features/blog_details/viewmodel/blogs_details_bloc.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:blog_client/features/create_blog/viewmodel/create_blog_bloc.dart';
import 'package:blog_client/features/followers_followings/viewmodel/follow_followings_bloc.dart';
import 'package:blog_client/features/profile/viewmodel/profile_bloc.dart';
import 'package:blog_client/features/search/viewmodel/search_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load(fileName: '.env');
  await configureDependencies();
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<BlogsBloc>()),
        BlocProvider(create: (_) => getIt<BlogDetailsBloc>()),
        BlocProvider(create: (_) => getIt<CreateBlogBloc>()),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
        BlocProvider(create: (_) => getIt<FollowFollowingsBloc>()),
        BlocProvider(create: (_) => getIt<SearchBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightThemeMode(context),
      routerConfig: _appRouter.config(),
    );
  }
}
