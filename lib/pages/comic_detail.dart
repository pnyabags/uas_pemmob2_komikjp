import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/library_services.dart';
import '../models/model_comic.dart';
import '../widgets/select_category.dart';
import '../widgets/edit_category.dart';

class ComicDetail extends StatelessWidget {
  final Comic comic;

  const ComicDetail({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(comic.title), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// COVER
            Image.asset(
              comic.cover,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    comic.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// META INFO
                  _infoRow('Author', comic.author),
                  _infoRow('Artist', comic.artist),
                  _infoRow('Status', comic.status),

                  const SizedBox(height: 16),

                  /// SYNOPSIS
                  const Text(
                    'Synopsis',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(comic.synopsis, style: const TextStyle(height: 1.4)),

                  const SizedBox(height: 24),

                  /// ADD COMIC TO LIBRARY USER BUTTON
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('library')
                        .doc(comic.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final isInLibrary = snapshot.data?.exists ?? false;

                      return Column(
                        children: [
                          /// =========================
                          /// ADD / REMOVE LIBRARY
                          /// =========================
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(
                                isInLibrary
                                    ? Icons.delete_outline
                                    : Icons.library_add,
                              ),
                              label: Text(
                                isInLibrary
                                    ? 'Hapus dari Pustaka'
                                    : 'Tambah ke Pustaka',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isInLibrary
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                              ),
                              onPressed: () {
                                if (isInLibrary) {
                                  /// MENGHAPUS DARI LIBRARY
                                  LibraryService.removeFromLibrary(comic.id);
                                } else {
                                  /// MENAMBAHKAN KE LIBRARY DENGAN MEMILIH KATEGORI
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (_) => SelectCategory(
                                      onConfirm: (categories) {
                                        LibraryService.addToLibrary(
                                          comic,
                                          categories,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// EDIT CATEGORY
                          if (isInLibrary)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Kategori'),
                                onPressed: () {
                                  final data =
                                      snapshot.data!.data()
                                          as Map<String, dynamic>;

                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (_) => EditCategory(
                                      comicId: comic.id,
                                      currentCategories: List<String>.from(
                                        data['categories'] ?? [],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  /// CHAPTER LIST
                  const Text(
                    'Chapters',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            /// CHAPTERS
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comic.chapters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Chapter ${comic.chapters[index]}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // open reader later
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text('$label: $value', style: const TextStyle(color: Colors.grey)),
    );
  }
}
