// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';

import '../services/authentication_service.dart';
import '../utils/api_controller.dart';

class PermissionsController extends ApiController {
  PermissionsController(this._authenticationService);

  final AuthenticationService _authenticationService;

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/permissions',
      permissionsHandler,
    );
  }

  Response permissionsHandler(Request request) {
    final headers = request.headers;
    if (!headers.containsKey(AuthenticationService.authHeader)) {
      return responseBuilder.buildOK(data: {
        'DashboardRoute': false,
        'ProfileRoute': false,
        'SplashRoute': true,
        'NotificationsRoute': false,
        'LoginRoute': true,
      });
    }

    _authenticationService.isAuthenticated(request);

    return responseBuilder.buildOK(data: {
      'DashboardRoute': true,
      'ProfileRoute': true,
      'SplashRoute': true,
      'NotificationsRoute': true,
      'LoginRoute': true,
    });
  }
}
