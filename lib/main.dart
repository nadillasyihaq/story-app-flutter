import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/data/api/api_service.dart';
import 'package:story_app_flutter/data/model/story.dart';
import 'package:story_app_flutter/data/preferences/auth_preferences.dart';
import 'package:story_app_flutter/data/preferences/country_code_preference.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';
import 'package:story_app_flutter/provider/localizations_provider.dart';
import 'package:story_app_flutter/provider/pick_image_provider.dart';
import 'package:story_app_flutter/provider/post_story_provider.dart';
import 'package:story_app_flutter/provider/story_provider.dart';
import 'package:story_app_flutter/routes/router_delegate.dart';

void main() {
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late AppRouterDelegate appRouterDelegate;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    final authPreferences = AuthPreferences();
    authProvider = AuthProvider(authPreferences, ApiService());

    appRouterDelegate = AppRouterDelegate(authPreferences);
  }

  Story? selectedStory;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoryProvider(
            apiService: ApiService(),
            authRepository: AuthPreferences(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PickImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              PostStoryProvider(ApiService(), AuthPreferences()),
        ),
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider<LocalizationProvider>(
          create: (context) =>
              LocalizationProvider(ccPrefs: CountryCodePreferences()),
        ),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            locale: provider.locale,
            title: 'Story App',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: Router(
              routerDelegate: appRouterDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}
