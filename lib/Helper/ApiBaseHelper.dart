// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'exceptions.dart';

int statusCode = 0;

class Auth {
  static var authenticationToken;
  static var userId;
  static bool isLoggedIn = false;
}

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}

class ApiBaseHelper {
  Future<dynamic> getAPICall(Uri url) async {
    var responseJson;
    print("url : $url");
    print('Authorization: Bearer ${Auth.authenticationToken}');
    try {
      final response = await get(
        url,
        headers: {
          // 'Authorization': 'Bearer ${Auth.authenticationToken}',
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(
          seconds: 60,
        ),
      );
      statusCode = response.statusCode;
      print("response : ${response.body.toString()}");

      print(" API = $url,response : ${response.body.toString()}");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }

  Future<dynamic> postAPICall(Uri url, Map parameter) async {
    var responseJson;
    print("parameter: $parameter, url: $url");
    print('Authorization: Bearer ${Auth.authenticationToken}');
    try {
      final response = await post(
        url,
        body: parameter.isNotEmpty ? parameter : null,
        headers: {
          // 'Authorization': 'Bearer ${Auth.authenticationToken}',
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(
          seconds: 60,
        ),
      );
      print(
        "response code: ${response.statusCode.toString()}, Parameter :$parameter, API: $url, response: ${response.body.toString()}",
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode: ${response.statusCode}',
        );
    }
  }
}
