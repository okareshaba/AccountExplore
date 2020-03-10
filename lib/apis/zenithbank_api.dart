import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show BaseClient, IOClient;

import 'package:http/http.dart' as http;
import 'package:zxplore_app/apis/endpoints.dart';
import 'package:zxplore_app/models/account_class_model.dart';
import 'package:zxplore_app/models/account_details_response.dart';
import 'package:zxplore_app/models/accounts_response.dart';
import 'package:zxplore_app/models/bvn_response.dart';
import 'package:zxplore_app/models/login_response.dart';
import 'package:zxplore_app/models/occupation_model.dart';
import 'package:zxplore_app/models/save_account_response.dart';
import 'package:zxplore_app/models/state_model.dart';
import 'package:zxplore_app/models/title_model.dart';
import 'package:zxplore_app/models/verify_account_response.dart';

class ZenithBankApi {
  Future<Occupation> fetchOccupations() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(Endpoints.getOccupationUrl()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return Occupation.fromJson(json.decode(reply));
    } else {
      throw CleanerException('Failed to load occupations');
    }
  }

  Future<AccountClass> fetchAccountClasses() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(Endpoints.getAccountClassesUrl()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return AccountClass.fromJson(json.decode(reply));
    } else {
      throw CleanerException('Failed to load account classes');
    }
  }

  Future<Title> fetchTitles() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(Endpoints.getTitlesUrl()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return Title.fromJson(json.decode(reply));
    } else {
      throw CleanerException('Failed to load titles');
    }
  }

  Future<State> fetchStates() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(Endpoints.getStatesUrl()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return State.fromJson(json.decode(reply));
    } else {
      throw CleanerException('Failed to load states');
    }
  }

  Future<State> fetchCities() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(Endpoints.getCitiesUrl()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return State.fromJson(json.decode(reply));
    } else {
      throw CleanerException('Failed to load cities');
    }
  }

  Future<State> fetchCountries() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request =
        await client.getUrl(Uri.parse(Endpoints.getCountriesUrl()));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return State.fromJson(json.decode(reply));
    } else {
      throw CleanerException('Failed to load countries');
    }
  }

  Future<LoginResponse> attemptLogin(String username, String password) async {
    Response response;
    Dio dio = new Dio();

    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };

      response = await dio.post(Endpoints.getLoginUrl(),
          data: {"UserName": username, "Password": password});

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        var value = LoginResponse.fromJson(response.data);
        throw CleanerException(value.data.responseMessage);
      } else {
        throw CleanerException('login failed.');
      }
    } on DioError catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == 400) {
          throw CleanerException("Invalid login details. Try again");
        } else if (error.response?.statusCode == 502) {
          var value = LoginResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else {
          throw CleanerException(_handleError(error));
        }
      } else {
        throw CleanerException(
            'We are having issues sending the account to the server. Try again later. ');
      }
    }
  }

  Future<AccountsResponse> getAllAccountsByRsmId(
      String rsmId, String token) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
      response =
          await dio.get("${Endpoints.getAccountsByRsmIdUrl()}$rsmId/All");
      return AccountsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
//      print("Exception occured: $error stackTrace: $stacktrace");
      throw CleanerException(_handleError(error));
    }
  }

  Future<AccountDetailsResponse> getAccountsDetailsByReference(
      String referenceId, String token) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
      response =
          await dio.get("${Endpoints.getAccountDetailsUrl()}$referenceId");
      return AccountDetailsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      throw CleanerException(_handleError(error));
    }
  }

  Future<VerifyAccountResponse> verifyAccountsByRefId(
      String referenceId, String token) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(
        Uri.parse("${Endpoints.getVerifyAccountsByRefIdUrl()}$referenceId"));
    request.headers.set('Authorization', 'Bearer $token');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      print(json.decode(reply));
      return VerifyAccountResponse.fromJson(json.decode(reply));
    } else if (response.statusCode == 400) {
      var errorResponse =
          VerifyAccountResponse().fromErrorJson(json.decode(reply));
      throw CleanerException(errorResponse.message);
    } else {
      throw CleanerException('Failed to load cities');
    }
  }

  Future<SaveAccountResponse> attemptSaveAccounts(
      String encodedJson, String token) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };

      response = await dio.post("${Endpoints.getSaveAccountsUrl()}",
          data: encodedJson);
      if (response.statusCode == 200) {
        return SaveAccountResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        var value = SaveAccountResponse.fromJson(response.data);
        throw CleanerException(value.message);
      } else {
        return SaveAccountResponse.fromJson(response.data);
      }
    } catch (error, stacktrace) {
      if (error is DioError) {
        if (error.response?.statusCode == 400) {
          var value = SaveAccountResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = SaveAccountResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else {
          throw CleanerException(_handleError(error));
        }
      } else {
        throw CleanerException(
            'We are having issues sending the account to the server. Try again later. ');
      }
    }
  }

  Future<String> loadCertificateAsset() async {
    return await rootBundle.loadString('assets/server_certificate.crt');
  }

  Future<BvnResponse> verifyBvn(String encodedBvn, String token) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };

      response =
          await dio.post(Endpoints.getBvnUrl(), data: {"BvnNew": encodedBvn});

      if (response.statusCode == 200) {
        return BvnResponse.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        var value = LoginResponse.fromJson(response.data);
        throw CleanerException(value.message);
      } else {
        throw CleanerException(
            'BVN Verification failed in connecting to the server.');
      }
    } catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == 400) {
          var value = SaveAccountResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else if (error.response?.statusCode == 502) {
          var value = SaveAccountResponse.fromJson(error.response?.data);
          throw CleanerException(value.message);
        } else {
          throw CleanerException(_handleError(error));
        }
      } else {
        throw CleanerException(
            'We are having issues sending the account to the server. Try again later. ');
      }
    }
  }

  String _handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          if (error.response?.statusCode == 401) {
            errorDescription = "Session expired. Kindly login again.";
          } else {
            errorDescription =
                "Received invalid status code: ${error.response.statusCode}";
          }

          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}

class CleanerException implements Exception {
  String cause;

  CleanerException(this.cause);

  @override
  String toString() {
    return cause;
  }
}
