import 'package:flutter/material.dart';
import 'package:story_app_flutter/data/model/story.dart';
import 'package:story_app_flutter/utils/date_time_format.dart';

class StoryItem extends StatelessWidget {
  final Story storyItem;

  const StoryItem({
    super.key,
    required this.storyItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 40,
                child: Image.asset(
                  'assets/images/user_blue.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    storyItem.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  Text(
                    dateTimeFormat(storyItem.createdAt, context),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(115, 25, 18, 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: storyItem.photoUrl,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 270,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            storyItem.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
