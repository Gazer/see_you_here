
import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';

class AuthInterceptorSingleton {
  static String token;

  static AuthInterceptor get instance => AuthInterceptor(token);
}

@immutable
class AuthInterceptor extends RequestInterceptor {
  final String token;

  AuthInterceptor(this.token);

  @override
  FutureOr<Request> onRequest(Request request) {
    if (token != null) {
      final headers = Map<String, String>.from(request.headers);
      headers['X-AUTH'] = token;

      request = request.copyWith(headers: headers);
    }

    return request;
  }

}