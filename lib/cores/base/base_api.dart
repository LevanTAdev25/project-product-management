import 'package:dio/dio.dart';
import 'package:prjgetxmvc/cores/api/data_api_config.dart';
import 'package:prjgetxmvc/cores/base/base_handle_response.dart';

class BaseApi {
  final Dio dio = DataApi().dio;
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<Response> post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<Response> put(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await dio.put(path, data: data);
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      BaseHandleResponse.handleDioResponse(e);
    }
  }
}
