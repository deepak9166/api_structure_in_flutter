import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:api_stracture/api_serivce/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'api_image_model.dart';
import 'base_api_model.dart';
import 'network_calls.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

class AppApi {
  static final netWorkCalls = NetworkCalls();

  /// Post api example
  static Future<Resource> apiPostFunction(Map body) async {
    return resource(ApiUrl.signIn, body, sendToken: false).then((response) {
      return response.data;
    });
  }

  /// Post api with upload image example
  static Future<Resource> apiPostFunctionWithFileUpload(
      Map body, List<ApiImageModel> images) async {
    return imageUpload(ApiUrl.signIn, body, sendToken: true, imagesList: images)
        .then((response) {
      return response.data;
    });
  }

  /// Get api example
  static Future<Resource> getApiFunction() async {
    return resourceGet(ApiUrl.signIn, sendToken: true).then((response) {
      return response.data;
    });
  }

  ///**Image updload function */
  static Future<Resource> imageUpload(String url, Map body,
      {required List<ApiImageModel> imagesList, bool sendToken = false}) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    request.headers["Content-Type"] = "multipart/form-data";
    // var user = HiveServices.getUser();

    if (sendToken) {
      /// handle token in token stored in local, here we can fetch token and send with header [Authorization] key
      // request.headers["Authorization"] = user!.token!;
    }
    body.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // image upload
    if (imagesList.isNotEmpty) {
      if (kIsWeb) {
        for (var i = 0; i < imagesList.length; i++) {
          var img = imagesList[i].file as PickedFile;
          var key = imagesList[i].keyName;
          Uint8List data = await img.readAsBytes();
          List<int> list = data.cast();
          request.files.add(http.MultipartFile.fromBytes(key, list,
              filename: basename(img.path)));
        }
      } else {
        for (var i = 0; i < imagesList.length; i++) {
          var img = imagesList[i].file as File;
          var key = imagesList[i].keyName;
          // open a bytestream
          var stream = http.ByteStream(DelegatingStream.typed(img.openRead()));
          // get file length
          var length = await img.length();
          var multipartFile = http.MultipartFile(key, stream, length,
              filename: basename(img.path));
          request.files.add(multipartFile);
        }
      }
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        String value = await response.stream.transform(utf8.decoder).join();
        var baseApiModel = BaseApiModel.fromJson(jsonDecode(value));

        if (baseApiModel.statusCode == 200) {
          return Resource.success(baseApiModel.data, baseApiModel.message);
        } else {
          return Resource.error({}, baseApiModel.message);
        }
      } else {
        // String value = await response.stream.transform(utf8.decoder).join();

        return Resource.error({}, "Somthing went wrong!");
      }
    } catch (e) {
      return Resource.error({}, "Somthing went wrong!");
    }
  }

  /// handle response getting from api and use commond function for all api to handle response
  static Future<Resource> resource(String url, Map body,
      {bool sendToken = false}) async {
    print("Api Body : ${jsonEncode(body)}   \n\nApi Url:>> $url \n");

    return commonPostMethod(url, body, sendToken: sendToken).then((response) {
      BaseApiModel? baseApiModel = BaseApiModel.fromJson(jsonDecode(response));
      if (baseApiModel.statusCode == 200) {
        return Resource.success(baseApiModel.data, baseApiModel.message);
      } else if (baseApiModel.statusCode == 400) {
        return Resource.error({}, baseApiModel.message);
      } else if (baseApiModel.statusCode == 401) {
        return Resource.expair({}, baseApiModel.message);
      } else {
        return Resource.error({}, baseApiModel.message);
      }
    });
  }

  static Future<Resource> resourceGet(String url,
      {bool sendToken = false}) async {
    return commonGetMethod(url, sendToken: sendToken).then((response) {
      BaseApiModel? baseApiModel = BaseApiModel.fromJson(jsonDecode(response));

      if (baseApiModel.statusCode == 200) {
        return Resource.success(baseApiModel.data, baseApiModel.message);
      } else if (baseApiModel.statusCode == 400) {
        return Resource.error({}, baseApiModel.message);
      } else if (baseApiModel.statusCode == 401) {
        return Resource.expair({}, baseApiModel.message);
      } else {
        return Resource.error({}, baseApiModel.message);
      }
    });
  }

  /// Comman Post method for all post apis
  static Future commonPostMethod(String url, Map params,
      {bool sendToken = true}) async {
    Map<String, String> header = {};
    if (sendToken) {
      /// Get token form local and pass header [Authorization] key , if you get [sendToken] true

      // var user = HiveServices.getUser();
      // if (user != null) {
      //   header.putIfAbsent("Authorization", () => user.token ?? "");
      // }
    }
    header.putIfAbsent("content-type", () => "application/json");
    var response = await netWorkCalls.post(url, jsonEncode(params), header);
    return response;
  }

  /// Comman Get method for all post apis
  static Future commonGetMethod(String url, {bool sendToken = true}) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    if (sendToken) {
      /// Get token form local and pass header [Authorization] key , if you get [sendToken] true

      // var user = HiveServices.getUser();
      // await header.putIfAbsent("Authorization", () => user?.token ?? "");
    }
    var response = await netWorkCalls.get(url, header);
    return response;
  }
}

class ApiUrl {
  /// All apis url collection
  static const baseUrl = "<base url of you api>";
  static const signIn = baseUrl + "login";
}
