import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/model_comic.dart';

class LibraryService {
  static final _db = FirebaseFirestore.instance;
  static String get _uid => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference get _libraryRef =>
      _db.collection('users').doc(_uid).collection('library');

  /// STREAM LIBRARY (REAL-TIME)
  static Stream<QuerySnapshot> streamLibrary() {
    return _libraryRef.orderBy('addedAt', descending: true).snapshots();
  }

  /// CHECK EXIST
  static Future<bool> isInLibrary(String comicId) async {
    final doc = await _libraryRef.doc(comicId).get();
    return doc.exists;
  }

  /// ADD TO LIBRARY
  static Future<void> addToLibrary(
    Comic comic,
    List<String> categoryIds,
  ) async {
    await _libraryRef.doc(comic.id).set({
      'title': comic.title,
      'cover': comic.cover,
      'categories': categoryIds.isEmpty ? ['uncategorized'] : categoryIds,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  /// REMOVE FROM LIBRARY
  static Future<void> removeFromLibrary(String comicId) async {
    await _libraryRef.doc(comicId).delete();
  }

  /// UPDATE CATEGORIES
  static Future<void> updateCategories(
    String comicId,
    List<String> newCategoryIds,
  ) async {
    final ref = _libraryRef.doc(comicId);

    if (newCategoryIds.isEmpty) {
      // keluar dari library jika tidak ada kategori
      await ref.delete();
    } else {
      await ref.update({'categories': newCategoryIds});
    }
  }
}
