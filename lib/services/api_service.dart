import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/utils/email_utility.dart';
import '../models/leads_model.dart';
import '../models/leads_model_with_user.dart';
import '../models/list/lead_list.dart';
import '../models/list/property_list.dart';
import '../models/property_model.dart';
import '../utils/helper_method.dart';

import '../main.dart';
import '../models/list/lead_with_user_list.dart';
import '../models/list/user_list.dart';
import '../models/user_model.dart';
import '../utils/api.dart';
import '../utils/enum.dart';
import '../utils/preference_key.dart';
import 'snakbar_service.dart';

enum ApiStatus { ideal, loading, success, failed }

class ApiProvider extends ChangeNotifier {
  ApiStatus? status = ApiStatus.ideal;
  late Dio _dio;
  static ApiProvider instance = ApiProvider();
  ApiProvider() {
    _dio = Dio();
    if (!kIsWeb) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
    }
  }

  Future<bool> createUser(UserModel user) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Map<String, dynamic> reqBody = user.toMap();
      reqBody.remove('id');
      log(json.encode(reqBody));
      Response response = await _dio.post(
        Api.user,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      debugPrint(response.toString());
      if (response.statusCode == 201) {
        SnackBarService.instance
            .showSnackBarSuccess('User profile is created.');
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    status = ApiStatus.loading;
    UserModel? userModel;
    notifyListeners();
    log('${Api.user}mobileNo/$phone');
    try {
      Response response = await _dio.get(
        '${Api.user}mobileNo/$phone',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        userModel = UserModel.fromMap(response.data['data']);
        prefs.setInt(SharedpreferenceKey.userId, userModel.id ?? 0);
        status = ApiStatus.success;
        notifyListeners();
        return userModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      debugPrint(e.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['errors'][0]['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return userModel;
  }

  Future<UserModel?> getUserById(int id) async {
    status = ApiStatus.loading;
    UserModel? userModel;
    notifyListeners();

    try {
      Response response = await _dio.get(
        '${Api.user}$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        userModel = UserModel.fromMap(response.data['data']);

        status = ApiStatus.success;
        notifyListeners();
        return userModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return userModel;
  }

  Future<bool> createLead(LeadsModel lead) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Map<String, dynamic> reqBody = lead.toMap();
      reqBody.remove('id');
      reqBody.remove('createdDate');
      reqBody.remove('updatedDate');
      log(json.encode(reqBody));
      Response response = await _dio.post(
        Api.leads,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      debugPrint(response.toString());
      if (response.statusCode == 201) {
        status = ApiStatus.failed;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<bool> updateUser(Map<String, dynamic> user, int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.put(
        '${Api.user}$id',
        data: json.encode(user),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<bool> updatePropety(Map<String, dynamic> property, int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.put(
        '${Api.properties}$id',
        data: json.encode(property),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<bool> deletePropety(int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.delete(
        '${Api.properties}$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<UserListModel?> getAllUsers() async {
    status = ApiStatus.loading;
    UserListModel? userModel;
    notifyListeners();

    try {
      Response response = await _dio.get(
        Api.user,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        userModel = UserListModel.fromMap(response.data);

        status = ApiStatus.success;
        notifyListeners();
        return userModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return userModel;
  }

  Future<LeadListModel?> getAllLeadsByUserId(int userId) async {
    status = ApiStatus.loading;
    LeadListModel? leadListModel;
    notifyListeners();

    try {
      Response response = await _dio.get(
        '${Api.leads}createdby/$userId',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        leadListModel = LeadListModel.fromMap(response.data);

        status = ApiStatus.success;
        notifyListeners();
        return leadListModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return leadListModel;
  }

  Future<LeadsModel?> getLeadsById(int leadId) async {
    status = ApiStatus.loading;
    LeadsModel? leadsModel;
    notifyListeners();
    log('${Api.leads}$leadId');
    try {
      Response response = await _dio.get(
        '${Api.leads}$leadId',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        leadsModel = LeadsModel.fromMap(response.data['data']);

        status = ApiStatus.success;
        notifyListeners();
        log('resp : $leadsModel');
        return leadsModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return leadsModel;
  }

  Future<bool> updateLead(Map<String, dynamic> lead, int id) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      log('${Api.leads}$id');
      log('${json.encode(lead)}');
      Response response = await _dio.put(
        '${Api.leads}$id',
        data: json.encode(lead),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<bool> createProperty(PropertyModel property) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Map<String, dynamic> reqBody = property.toMap();
      reqBody.remove('id');
      reqBody.remove('createdDate');
      reqBody.remove('updatedDate');
      log(json.encode(reqBody));
      Response response = await _dio.post(
        Api.properties,
        data: json.encode(reqBody),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      debugPrint(response.toString());
      if (response.statusCode == 201) {
        status = ApiStatus.failed;
        notifyListeners();
        // SnackBarService.instance.showSnackBarSuccess('Lead created');
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<PropertyListModel?> getAllProperties(
      String city, String propertyType) async {
    status = ApiStatus.loading;
    PropertyListModel? propertyListModel;
    notifyListeners();

    try {
      Response response = await _dio.get(
        '${Api.properties}city/?city=$city&propertyType=$propertyType',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        propertyListModel = PropertyListModel.fromMap(response.data);

        status = ApiStatus.success;
        notifyListeners();
        return propertyListModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return propertyListModel;
  }

  Future<PropertyModel?> getPropertyById(int id) async {
    status = ApiStatus.loading;
    PropertyModel? propertyModel;
    notifyListeners();

    try {
      Response response = await _dio.get(
        '${Api.properties}$id',
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        propertyModel = PropertyModel.fromMap(response.data['data']);

        status = ApiStatus.success;
        notifyListeners();
        return propertyModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return propertyModel;
  }

  Future<PropertyListModel?> getAllFavProperties(List<int> ids) async {
    status = ApiStatus.loading;
    PropertyListModel? propertyListModel;
    notifyListeners();
    Map<String, List<int>> req = {"ids": ids};
    try {
      Response response = await _dio.post(
        '${Api.properties}get-multiple',
        data: json.encode(req),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        propertyListModel = PropertyListModel.fromMap(response.data);

        status = ApiStatus.success;
        notifyListeners();
        return propertyListModel;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return propertyListModel;
  }

  Future<bool> sendOtp(String phone, String otp) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      debugPrint(Api.buildOtpUrl(phone, otp));
      Response response = await _dio.get(
        Api.buildOtpUrl(phone, otp),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        SnackBarService.instance.showSnackBarInfo('OTP sent');
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }

  Future<Map<UserModel, int>?> getAllLeads() async {
    status = ApiStatus.loading;
    LeadWithUserListModel? leadListModel;
    Map<UserModel, int>? userMap = {};
    notifyListeners();

    try {
      Response response = await _dio.get(
        Api.leads,
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        leadListModel = LeadWithUserListModel.fromMap(response.data);
        for (LeadsModelWithUser lead in leadListModel.data ?? []) {
          if (containsUser(userMap, lead.createdById!) == 0) {
            userMap[lead.createdBy!] = 1;
          } else {
            userMap[lead.createdBy!] = 1 + userMap[lead.createdBy!]!;
          }
        }

        status = ApiStatus.success;
        notifyListeners();
        return userMap;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      // SnackBarService.instance
      //     .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      log(e.toString());
    }
    return userMap;
  }

  Future<bool> sendEnquiryEmail(
      UserModel userModel, String message, int propertyId) async {
    status = ApiStatus.loading;
    notifyListeners();
    try {
      Response response = await _dio.post(
        Api.sendEmail,
        data: json.encode(
            EmailUtility.getEmailBody(userModel, propertyId, message).toMap()),
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        SnackBarService.instance.showSnackBarSuccess('Enquiry Sent');
        status = ApiStatus.success;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      status = ApiStatus.failed;
      var resBody = e.response?.data ?? {};
      log(e.response?.data.toString() ?? e.response.toString());
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${resBody['message']}');
    } catch (e) {
      status = ApiStatus.failed;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
      log(e.toString());
    }
    status = ApiStatus.failed;
    notifyListeners();
    return false;
  }
}
