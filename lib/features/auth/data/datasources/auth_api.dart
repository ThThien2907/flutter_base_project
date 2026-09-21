import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_base_project/core/network/models/base_error.dart';
import 'package:flutter_base_project/core/network/models/base_response.dart';
import 'package:flutter_base_project/features/auth/data/models/request/login_request.dart';
import 'package:flutter_base_project/features/auth/data/models/response/login_response.dart';
import 'package:flutter_base_project/features/auth/data/models/response/user_response.dart';

part 'auth_api.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/api/v1/auth/login')
  Future<BaseResponse<LoginResponse, BaseError>> login(
    @Body() LoginRequest body,
  );

  @GET('/api/v1/auth/me')
  Future<BaseResponse<UserResponse, BaseError>> fetchUserData();

  @POST('/api/v1/auth/logout-session')
  Future<BaseResponse<dynamic, BaseError>> logout();
}
