import 'package:flutter/material.dart';
import '../widgets/comic_card.dart';
import '../data/data_comic.dart';

class Browse extends StatelessWidget {
  const Browse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jelajahi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // search
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dataComic.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          return ComicCard(comic: dataComic[index]);
        },
      ),
    );
  }
}
