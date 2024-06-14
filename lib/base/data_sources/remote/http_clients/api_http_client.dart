import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../../../lib_auth/data_sources/remote/interceptors/auth_interceptor.dart';
import '../interceptors/log_interceptor.dart';

/// An HTTP client for use with the main backed API.
class ApiHttpClient with DioMixin implements Dio {
  ApiHttpClient() {
    options = BaseOptions();
    httpClientAdapter = IOHttpClientAdapter();
  }

  final logInterceptor = createDioEventLogInterceptor('ApiHttpClient');
  late AuthInterceptor authInterceptor;

  void configureInterceptors(
    AuthInterceptor authInterceptor,
  ) {
    this.authInterceptor = authInterceptor;

    interceptors.addAll([
      logInterceptor,
      authInterceptor,
    ]);
  }

  @override
  Future<Response> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      Object? data,
      Options? options}) {
    // TODO: implement download
    throw UnimplementedError();
  }
}
