
part of 'injection_container.dart';

final sl = GetIt.instance;
Future<void> init() async {
  await _initonBoarding();
  await _initAuth();
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
        () => AuthBloc(signIn: sl(), signUp: sl(), forgotPassword: sl(),
         updateUser: sl(),),)
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        authClient: sl(), dbClient: sl(), cloudStoreClient: sl()))
        ..registerLazySingleton(() => FirebaseAuth.instance )
        ..registerLazySingleton(() => FirebaseFirestore.instance)
        ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initonBoarding() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: CacheFirstTimer(sl()),
        checkIfUserFirstTimer: CheckIfUserFirstTimer(sl()),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSrcImpl(
        sl(),
      ),
    )
    ..registerLazySingleton(() => prefs);
}
