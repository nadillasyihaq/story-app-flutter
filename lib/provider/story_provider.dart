import 'package:flutter/material.dart';
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/data/model/story.dart';
import 'package:story_app_flutter/data/result_state.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthPreferences authRepository;

  StoryProvider({
    required this.apiService,
    required this.authRepository,
  });

  ResultState resultState = ResultState.initial;
  String message = "";

  bool storyError = false;

  List<Story> stories = [];

  int? pageItems = 1;
  int sizeItems = 15;

  Future<void> getStories() async {
    try {
      if (pageItems == 1) {
        resultState = ResultState.loading;
        notifyListeners();
      }

      final userToken = await authRepository.getToken() ?? '';
      final storyResults = await apiService.getStories(
        userToken,
        pageItems!,
        sizeItems,
      );

      stories.addAll(storyResults.listStory);
      message = "Successfully loaded data";
      storyError = false;
      resultState = ResultState.loaded;

      if (storyResults.listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }

      notifyListeners();
    } catch (e) {
      resultState = ResultState.error;
      storyError = true;
      message = "Failed to load data";
      notifyListeners();
    }
  }

  Future<void> refreshStories() async {
    pageItems = 1;
    stories = [];
    message = "";
    notifyListeners();

    getStories();
  }
}
