import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/model/post_response.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';

class PostStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences authRepository;

  PostStoryProvider(this.apiService, this.authRepository);

  bool isUploading = false;
  String message = "";
  PostResponse? postResponse;
  String userToken = "";

  bool _isPosted = false;
  bool get isPosted => _isPosted;

  Future<bool> postStory(
    List<int> bytes,
    String fileName,
    String descripiton,
    double? lat,
    double? lng,
  ) async {
    try {
      message = "";
      postResponse = null;
      isUploading = true;
      notifyListeners();

      userToken = await authRepository.getToken() ?? "";

      postResponse = await apiService.postNewStory(
          bytes, fileName, descripiton, userToken, lat, lng);

      _isPosted = (postResponse!.error == false) ? true : false;
      notifyListeners();

      message = postResponse?.message ?? "Success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      _isPosted = false;
      isUploading = false;
      message = "Error: $e";
      notifyListeners();
    }

    return _isPosted;
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      newByte = img.encodeJpg(image, quality: compressQuality);
      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }
}
