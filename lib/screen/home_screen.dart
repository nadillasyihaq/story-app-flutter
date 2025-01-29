import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/data/model/story.dart';
import 'package:story_app_flutter/data/result_state.dart';
import 'package:story_app_flutter/provider/story_provider.dart';
import 'package:story_app_flutter/widget/error_message.dart';
import 'package:story_app_flutter/widget/story_item.dart';

class HomeScreen extends StatefulWidget {
  final Function(Story) onTapped;
  final Function() toPostStoryScreen;
  final Function() toSettingScreen;

  const HomeScreen({
    super.key,
    required this.onTapped,
    required this.toPostStoryScreen,
    required this.toSettingScreen,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storyProvider = context.read<StoryProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyProvider.pageItems != null) {
          storyProvider.getStories();
        }
      }
    });

    Future.microtask(() async => storyProvider.getStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Storizzme',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 27.0,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<StoryProvider>().refreshStories();
            },
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              widget.toSettingScreen();
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, value, _) {
          final state = value.resultState;

          if (state == ResultState.loading && value.pageItems == 1) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          } else if (state == ResultState.loaded) {
            final List<Story> storyList = value.stories;

            return ListView.separated(
              controller: scrollController,
              itemCount: storyList.length + (value.pageItems != null ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                if (index == storyList.length && value.pageItems != null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.pink,
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => widget.onTapped(storyList[index]),
                  child: StoryItem(
                    storyItem: storyList[index],
                  ),
                );
              },
            );
          } else if (state == ResultState.noData) {
            return const ErrorMessage(
              title: 'Not Found',
              desc: 'Belum ada data yang ditambahkan',
              icon: Icons.search,
            );
          } else {
            return const ErrorMessage(
              title: 'Sorry',
              desc: 'Gagal memuat data',
              icon: Icons.error_outline,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.toPostStoryScreen();
        },
        tooltip: 'Add New Story',
        shape: const CircleBorder(),
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
      ),
    );
  }
}
