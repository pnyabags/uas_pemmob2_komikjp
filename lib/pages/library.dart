import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/library_services.dart';
import '../services/category_services.dart';
import '../models/model_comic.dart';
import '../widgets/comic_card.dart';
import '../widgets/filter_komik.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pustaka'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const FilterKomik(),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: LibraryService.streamLibrary(),
        builder: (context, libSnap) {
          if (!libSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final libraryDocs = libSnap.data!.docs;

          if (libraryDocs.isEmpty) {
            return const Center(child: Text('Pustaka kosong'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: CategoryService.streamCategories(),
            builder: (context, catSnap) {
              if (!catSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final categories = catSnap.data!.docs;

              return ListView(
                children: categories.map((cat) {
                  final catId = cat.id;
                  final catName = (cat.data() as Map<String, dynamic>)['name'];

                  /// FILTER KOMIK UNTUK CATEGORY
                  final comicsInCategory = libraryDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final comicCategories = List<String>.from(
                      data['categories'] ?? [],
                    );
                    return comicCategories.contains(catId);
                  }).toList();

                  /// JIKA CATEGORY KOSONG, JANGAN TAMPILKAN
                  if (comicsInCategory.isEmpty) {
                    return const SizedBox();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// JUDUL CATEGORY
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          catName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /// LIST KOMIK (HORIZONTAL)
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: comicsInCategory.length,
                          itemBuilder: (context, index) {
                            final data =
                                comicsInCategory[index].data()
                                    as Map<String, dynamic>;

                            final comic = Comic.fromLibrary(
                              comicsInCategory[index].id,
                              data,
                            );

                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 120,
                                child: ComicCard(comic: comic),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
