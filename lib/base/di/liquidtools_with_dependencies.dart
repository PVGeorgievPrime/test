// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../feature_splash/services/splash_service.dart';

import '../../lib_auth/blocs/user_account_bloc.dart';
import '../../lib_auth/data_sources/local/auth_token_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_secure_data_source.dart';
import '../../lib_auth/data_sources/local/auth_token_shared_dara_source.dart';
import '../../lib_auth/data_sources/remote/auth_data_source.dart';
import '../../lib_auth/data_sources/remote/refresh_token_data_source.dart';
import '../../lib_auth/repositories/auth_repository.dart';
import '../../lib_auth/services/access_token_service.dart';
import '../../lib_auth/services/auth_service.dart';
import '../../lib_auth/services/user_account_service.dart';
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/data_sources/language_local_data_source.dart';
import '../../lib_change_language/repositories/language_repository.dart';
import '../../lib_change_language/services/app_language_service.dart';
import '../../lib_permissions/data_sources/remote/permissions_remote_data_source.dart';
import '../../lib_permissions/repositories/permissions_repository.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../../lib_router/services/router_service.dart';
import '../../lib_translations/di/translations_dependencies.dart';
import '../app/config/environment_config.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_blocs/push_notifications_bloc.dart';
import '../common_mappers/error_mappers/error_mapper.dart';
import '../common_services/push_notifications_service.dart';
import '../data_sources/local/profile_local_data_source.dart';
import '../data_sources/local/shared_preferences_instance.dart';
import '../data_sources/remote/http_clients/api_http_client.dart';
import '../data_sources/remote/http_clients/plain_http_client.dart';
import '../data_sources/remote/push_notification_data_source.dart';
import '../repositories/push_notification_repository.dart';

class LiquidtoolsWithDependencies extends StatelessWidget {
  const LiquidtoolsWithDependencies({
    required this.config,
    required this.child,
    super.key,
  });

  final EnvironmentConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        /// List of all providers used throughout the app
        providers: [
          ..._coordinator,
          _appRouter,
          ..._environment,
          ..._mappers,
          ..._httpClients,
          ..._dataStorages,
          ..._libs,
          ..._dataSources,
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: child,
      );

  List<SingleChildWidget> get _coordinator => [
        RxBlocProvider<CoordinatorBlocType>(
          create: (context) => CoordinatorBloc(),
        ),
      ];

  SingleChildWidget get _appRouter => Provider<AppRouter>(
        create: (context) => AppRouter(
          coordinatorBloc: context.read(),
        ),
      );

  List<Provider> get _environment => [
        Provider<EnvironmentConfig>.value(value: config),
      ];

  List<Provider> get _mappers => [
        Provider<ErrorMapper>(
          create: (context) => ErrorMapper(context.read()),
        ),
      ];

  List<Provider> get _httpClients => [
        Provider<PlainHttpClient>(
          create: (context) {
            return PlainHttpClient();
          },
        ),
        Provider<ApiHttpClient>(
          create: (context) {
            final client = ApiHttpClient()..options.baseUrl = config.baseUrl;
            return client;
          },
        ),
      ];

  List<SingleChildWidget> get _dataStorages => [
        Provider<SharedPreferencesInstance>(
            create: (context) => SharedPreferencesInstance()),
        Provider<FlutterSecureStorage>(
            create: (context) => const FlutterSecureStorage()),
        Provider<FirebaseMessaging>(
          create: (_) => FirebaseMessaging.instance,
        ),
      ];

  List<SingleChildWidget> get _libs => [
        ...TranslationsDependencies.from(baseUrl: config.baseUrl).providers,
      ];

  List<Provider> get _dataSources => [
        // Use different data source depending on the platform.
        Provider<AuthTokenDataSource>(
            create: (context) => kIsWeb
                ? AuthTokenSharedDataSource(context.read())
                : AuthTokenSecureDataSource(context.read())),
        Provider<AuthDataSource>(
          create: (context) => AuthDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<RefreshTokenDataSource>(
          create: (context) => RefreshTokenDataSource(
            context.read<PlainHttpClient>(),
            baseUrl: config.baseUrl,
          ),
        ),
        Provider<PushNotificationsDataSource>(
          create: (context) => PushNotificationsDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),

        Provider<PermissionsRemoteDataSource>(
          create: (context) => PermissionsRemoteDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),

        Provider<LanguageLocalDataSource>(
          create: (context) => LanguageLocalDataSource(
              context.read<SharedPreferencesInstance>()),
        ),
        Provider<ProfileLocalDataSource>(
          create: (context) =>
              ProfileLocalDataSource(context.read<SharedPreferencesInstance>()),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<PushNotificationRepository>(
          create: (context) => PushNotificationRepository(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<PermissionsRepository>(
          create: (context) => PermissionsRepository(
            context.read(),
            context.read(),
          ),
        ),
        Provider<LanguageRepository>(
          create: (context) => LanguageRepository(
            context.read<ErrorMapper>(),
            context.read<LanguageLocalDataSource>(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<AuthService>(
          create: (context) => AuthService(
            context.read(),
          ),
        ),
        Provider<PermissionsService>(
          create: (context) => PermissionsService(
            context.read(),
          ),
        ),
        Provider<RouterService>(
          create: (context) => RouterService(
            context.read<AppRouter>().router,
            context.read(),
          ),
        ),
        Provider<UserAccountService>(
          create: (context) => UserAccountService(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        Provider<AccessTokenService>(
          create: (context) => AccessTokenService(
            context.read(),
          ),
        ),
        Provider<SplashService>(
          create: (context) => SplashService(
            context.read(),
            context.read(),
          ),
        ),
        Provider<AppLanguageService>(
          create: (context) => AppLanguageService(
            languageRepository: context.read<LanguageRepository>(),
          ),
        ),
        Provider<PushNotificationsService>(
          create: (context) => PushNotificationsService(
            context.read(),
          ),
        ),
      ];

  List<SingleChildWidget> get _blocs => [
        Provider<RouterBlocType>(
          create: (context) => RouterBloc(
            router: context.read<AppRouter>().router,
            permissionsService: context.read(),
          ),
        ),
        RxBlocProvider<UserAccountBlocType>(
          create: (context) => UserAccountBloc(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        RxBlocProvider<ChangeLanguageBlocType>(
          create: (context) => ChangeLanguageBloc(
            languageService: context.read<AppLanguageService>(),
          ),
        ),
        RxBlocProvider<PushNotificationsBlocType>(
          create: (context) => PushNotificationsBloc(
            context.read(),
          ),
        ),
      ];
}
