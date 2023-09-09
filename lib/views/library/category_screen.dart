// import 'package:ai_story_maker/utils/text_style.dart';
// import 'package:ai_story_maker/views/auth/register_screen.dart';
// import 'package:flutter/material.dart';

// import '../home/home_screen.dart';

// class CategoriesScreen extends StatefulWidget {
//   const CategoriesScreen({super.key});

//   @override
//   CategoriesScreenState createState() => CategoriesScreenState();
// }

// class CategoriesScreenState extends State<CategoriesScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController =
//         TabController(length: 7, vsync: this); // 7 tabs for each category
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         const BackgroundImage(),
//         Positioned.fill(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               title: const Text(
//                 "Browse By Categories",
//                 style: sfBold,
//               ),
//               elevation: 0,
//               bottom: TabBar(
//                 controller: _tabController,
//                 isScrollable: true,
//                 unselectedLabelStyle: sfBold.copyWith(fontSize: 16),
//                 labelStyle: sfBold.copyWith(fontSize: 18),
//                 tabs: const [
//                   Tab(
//                     text: "Adventure",
//                   ),
//                   Tab(text: "Educational"),
//                   Tab(text: "Mood: Sad"),
//                   Tab(text: "Calming for Bed"),
//                   Tab(text: "By Time"),
//                   Tab(text: "By Age"),
//                   Tab(text: "Top Rated"),
//                 ],
//               ),
//             ),
//             body: TabBarView(
//               controller: _tabController,
//               children: [
//                 // Adventure stories
//                 buildCategoryTab("Adventure"),

//                 // Educational stories
//                 buildCategoryTab("Educational"),

//                 // Mood: Sad stories
//                 buildCategoryTab("Mood: Sad"),

//                 // Calming for Bed stories
//                 buildCategoryTab("Calming for Bed"),

//                 // By Time stories
//                 buildCategoryTab("By Time"),

//                 // By Age stories
//                 buildCategoryTab("By Age"),

//                 // Top Rated stories
//                 buildCategoryTab("Top Rated"),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildCategoryTab(String category) {
//     // Replace this with the actual content for each category
//     return Center(
//       child: GridView.builder(
//         padding: const EdgeInsets.all(16.0),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.8,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//         ),
//         itemCount: 10, // Replace with your actual data
//         itemBuilder: (context, index) {
//           return const NovelCard(
//             coverUrl:
//                 "https://www.childbook.ai/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fa10.855d2e83.webp&w=3840&q=75",
//             author: "Afjal",
//             story: "Novel 1",
//             name: "Novel 1",
//           );
//         },
//       ),
//     );
//   }
// }
