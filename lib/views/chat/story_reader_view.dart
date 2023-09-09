import 'package:ai_story_maker/utils/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryReader extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  final String? author;

  const StoryReader(
      {super.key, this.image, this.title, this.description, this.author});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Story",
          style: sfBold.copyWith(color: Colors.black, fontSize: 25),
        ),
        actions: [
          InkWell(
            onTap: () {
              _showShareOptions(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.share),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: image!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    title!,
                    style: sfBold.copyWith(fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    color: Colors.grey,
                    onPressed: () {
                      // Implement like functionality here
                    },
                  ),
                  const Text('100 Likes'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Published At : 10/06/2023",
                    style:
                        sfRegular.copyWith(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "By Author : Afjal",
                style: sfRegular.copyWith(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              Text(
                '''The Smith family had been scattered all over the world for many years, pursuing their own careers and interests. They hardly ever saw each other and had lost touch with most of their relatives. But one day, they received a letter from their elderly grandmother inviting them to a family reunion.
              
              At first, they were hesitant to go. Some of them had not seen each other in years, and there were tensions and conflicts that they had never resolved. However, their grandmother's letter was heartfelt, and they all realized that it was time to put their differences aside and come together as a family.
              
              The reunion was to be held in a large house in the countryside, and the family members made travel arrangements to arrive there from all over the world. There were cousins, aunts, uncles, and grandparents, all excited to reconnect with each other and relive old memories.
              
              When they arrived, they were greeted with hugs and tears of joy. It was a heartwarming scene as family members caught up on all the latest news and reminisced about old times. They spent the first day simply getting to know each other again, sharing meals and stories, and playing games.
              
              On the second day, they decided to take a walk around the countryside. They passed through fields and woods, and as they walked, they began to open up to each other, sharing their dreams, their hopes, and their struggles. It was a powerful moment as they realized how much they had missed out on by not staying in touch.
              
              That evening, they gathered around a bonfire, singing songs and roasting marshmallows. They shared stories of their childhoods, their parents, and their grandparents, and they all felt a sense of connection that they had not felt in years.
              
              On the third day, they decided to hold a family meeting to discuss their plans for the future. They talked about ways to stay in touch and support each other, no matter where in the world they were. They also talked about ways to resolve conflicts and disagreements, so that they could avoid the rifts that had separated them in the past.
              
              By the end of the reunion, the Smith family had grown closer than ever before. They had shared their love, their laughter, and their tears, and they had rediscovered the bond that had always been there, even if they had not always felt it.
              
              As they said their goodbyes and went their separate ways, they all knew that this was just the beginning of their journey as a family. They promised to keep in touch and to gather again in the future, and they all felt a sense of hope and optimism that they had not felt in years.
              
              From that day on, the Smith family remained closer than ever before. They made an effort to stay connected and to support each other, no matter what life threw their way. And they all knew that, no matter what the future held, they would always have each other. ''',
                textAlign: TextAlign.left,
                style:
                    sfSemiBold.copyWith(color: Colors.grey[800], fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _showShareOptions(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text(
          'Available Options',
          style: sfMedium.copyWith(color: Colors.black),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Implement share as text functionality here
            },
            child: Text(
              'Share as Text',
              style: sfMedium.copyWith(color: Colors.black),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Implement share as PDF functionality here
            },
            child: Text(
              'Share as PDF',
              style: sfMedium.copyWith(color: Colors.black),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Implement copy to clipboard functionality here
            },
            child: Text(
              'Copy to Clipboard',
              style: sfMedium.copyWith(color: Colors.black),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      );
    },
  );
}
