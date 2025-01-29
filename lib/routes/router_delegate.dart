import 'package:flutter/material.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/data/model/story.dart';
import 'package:story_app_flutter/screen/detail_screen.dart';
import 'package:story_app_flutter/screen/home_screen.dart';
import 'package:story_app_flutter/screen/login_screen.dart';
import 'package:story_app_flutter/screen/post_story_screen.dart';
import 'package:story_app_flutter/screen/register_screen.dart';
import 'package:story_app_flutter/screen/setting_screen.dart';
import 'package:story_app_flutter/screen/splash_screen.dart';

class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthPreferences authRepository;

  AppRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  Story? selectedStory;

  bool isGoToHome = false;
  bool isPostStory = false;
  bool isGoToSettings = false;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("Login Page"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          )
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          child: HomeScreen(
            key: const ValueKey("HomePage"),
            onTapped: (Story storyItem) {
              selectedStory = storyItem;
              notifyListeners();
            },
            toPostStoryScreen: () {
              isPostStory = true;
              notifyListeners();
            },
            toSettingScreen: () {
              isGoToSettings = true;
              notifyListeners();
            },
          ),
        ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey("DetailPage-${selectedStory!.id}"),
            child: DetailScreen(
              storyData: selectedStory!,
            ),
          ),
        if (isPostStory)
          MaterialPage(
            key: const ValueKey("PostStoryPage"),
            child: PostStoryScreen(
              toHomeScreen: () {
                isGoToHome = true;
                isPostStory = false;
                notifyListeners();
              },
            ),
          ),
        if (isGoToSettings)
          MaterialPage(
            key: const ValueKey("SettingScreen"),
            child: SettingScreen(
              onLogout: () {
                isLoggedIn = false;
                isGoToSettings = false;
                notifyListeners();
              },
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);

        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedStory = null;
        isPostStory = false;
        isGoToSettings = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
