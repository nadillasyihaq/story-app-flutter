import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:story_app_flutter/data/model/post_response.dart';
import 'package:story_app_flutter/data/model/login_response.dart';
import 'package:story_app_flutter/data/model/register_response.dart';
import 'package:story_app_flutter/data/model/story.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1/";

  Future<StoryResult> getStories(
    String userToken, [
    int page = 1,
    int size = 15,
  ]) async {
    var uri = Uri.parse('$_baseUrl/stories?page=$page&size=$size');

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $userToken",
      },
    );

    if (response.statusCode == 200) {
      return StoryResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load stories data');
    }
  }

  Future<LoginResponse> userLogin(
    String email,
    String password,
  ) async {
    var uri = Uri.parse('$_baseUrl/login');

    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    final response = await http.post(
      uri,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<RegisterResponse> userRegister(
    String name,
    String email,
    String password,
  ) async {
    var uri = Uri.parse('$_baseUrl/register');

    final Map<String, dynamic> requestBody = {
      "name": name,
      "email": email,
      "password": password,
    };

    final response = await http.post(uri, body: requestBody);

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<PostResponse> postNewStory(
    List<int> bytes,
    String fileName,
    String descripiton,
    String userToken,
    double? lat,
    double? lng,
  ) async {
    var uri = Uri.parse('$_baseUrl/stories');
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    
    final Map<String, String> fieldsWithLocation = {
      "description": descripiton,
      "lat": lat.toString(),
      "lon" : lng.toString(),
    };

    final Map<String, String> fieldsNoLocation = {
      "description": descripiton,
    };

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $userToken"
    };

    request.files.add(multiPartFile);
    request.fields.addAll(
      lat == null && lng == null ? fieldsNoLocation : fieldsWithLocation
    );
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final PostResponse response =
          PostResponse.fromJson(jsonDecode(responseData));
      return response;
    } else {
      throw Exception("Failed to post new story");
    }
  }
}
