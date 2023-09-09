import 'package:ai_story_maker/utils/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/app_button.dart';
import 'story_reader_view.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Community",
            style: sfBold.copyWith(fontSize: 25, color: Colors.black),
          )),
      body: SafeArea(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return _buildBookCard(books[index]);
          },
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return InkWell(
      onTap: () {
        Get.to(() => StoryReader(
              author: book.author.name,
              image: book.coverImageUrl,
              title: book.title,
              description: book.caption,
            ));
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 5)
            ]),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(book.author.profileImageUrl),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    book.author.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 80,
                      height: 50,
                      child: AppButton(
                        onTap: () {},
                        title: 'Follow',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.black,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: book.coverImageUrl,
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.caption,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            color: book.isLiked ? Colors.red : Colors.grey,
                            onPressed: () {
                              // Implement like functionality here
                            },
                          ),
                          Text('${book.likes} Likes'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String caption;
  final String coverImageUrl;
  final Author author;
  bool isLiked;
  int likes;

  Book({
    required this.title,
    required this.caption,
    required this.coverImageUrl,
    required this.author,
    this.isLiked = false,
    this.likes = 0,
  });
}

class Author {
  final String name;
  final String profileImageUrl;

  Author({required this.name, required this.profileImageUrl});
}

// Sample book data (Replace this with your actual data)
List<Book> books = [
  Book(
    title: 'Book 1',
    caption: 'This is the first book.',
    coverImageUrl:
        'https://ik.imagekit.io/storybird/images/dca08ec4-2d0e-4536-a659-a38973ce2dd9/0_213311201.png',
    author: Author(
      name: 'John Doe',
      profileImageUrl:
          'https://ik.imagekit.io/storybird/images/dca08ec4-2d0e-4536-a659-a38973ce2dd9/0_213311201.png',
    ),
    isLiked: false,
    likes: 10,
  ),
  Book(
    title: 'Book 2',
    caption: 'This is the second book.',
    coverImageUrl:
        'https://ik.imagekit.io/storybird/images/dca08ec4-2d0e-4536-a659-a38973ce2dd9/0_213311201.png',
    author: Author(
      name: 'Jane Smith',
      profileImageUrl:
          'https://ik.imagekit.io/storybird/images/dca08ec4-2d0e-4536-a659-a38973ce2dd9/0_213311201.png',
    ),
    isLiked: true,
    likes: 20,
  ),
  Book(
    title: 'Book 3',
    caption: 'This is the third book.',
    coverImageUrl:
        'https://ik.imagekit.io/storybird/images/dca08ec4-2d0e-4536-a659-a38973ce2dd9/0_213311201.png',
    author: Author(
      name: 'Robert Johnson',
      profileImageUrl:
          'https://ik.imagekit.io/storybird/images/dca08ec4-2d0e-4536-a659-a38973ce2dd9/0_213311201.png',
    ),
    isLiked: false,
    likes: 5,
  ),
];
