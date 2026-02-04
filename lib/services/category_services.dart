import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  static final _db = FirebaseFirestore.instance;
  static String get _uid => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference get _categoryRef =>
      _db.collection('users').doc(_uid).collection('categories');

  /// STREAM CATEGORY (REAL-TIME)
  static Stream<QuerySnapshot> streamCategories() {
    return _categoryRef.orderBy('order').snapshots();
  }

  /// ADD CATEGORY
  static Future<void> addCategory(String name) async {
    final snapshot = await _categoryRef.get();
    final order = snapshot.docs.length;

    await _categoryRef.add({'name': name, 'order': order, 'isDefault': false});
  }

  /// DELETE CATEGORY

  static Future<void> deleteCategory(String categoryId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final db = FirebaseFirestore.instance;
    final uid = user.uid;

    final categoryRef = db
        .collection('users')
        .doc(uid)
        .collection('categories');
    final libraryRef = db.collection('users').doc(uid).collection('library');

    final defaultQuery = await categoryRef
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();

    if (defaultQuery.docs.isEmpty) {
      throw Exception('Default category not found');
    }

    final defaultCategoryId = defaultQuery.docs.first.id;
    final librarySnapshot = await libraryRef.get();

    final batch = db.batch();

    for (final doc in librarySnapshot.docs) {
      final data = doc.data();

      final categories = data.containsKey('categories')
          ? List<String>.from(data['categories'])
          : <String>[defaultCategoryId];

      if (categories.contains(categoryId)) {
        categories.remove(categoryId);
      }

      if (categories.isEmpty) {
        categories.add(defaultCategoryId);
      }

      batch.update(doc.reference, {'categories': categories});
    }

    batch.delete(categoryRef.doc(categoryId));
    await batch.commit();

    /// REORDER CATEGORY
    final snapshot = await categoryRef.orderBy('order').get();
    final reorderBatch = db.batch();

    for (int i = 0; i < snapshot.docs.length; i++) {
      reorderBatch.update(snapshot.docs[i].reference, {'order': i});
    }

    await reorderBatch.commit();
  }

  /// UPDATE CATEGORY
  static Future<void> updateCategoryName(
    String categoryId,
    String newName,
  ) async {
    await _categoryRef.doc(categoryId).update({'name': newName});
  }

  /// REORDER CATEGORY
  static Future<void> updateOrder(List<QueryDocumentSnapshot> docs) async {
    final batch = _db.batch();

    for (int i = 0; i < docs.length; i++) {
      batch.update(docs[i].reference, {'order': i});
    }

    await batch.commit();
  }
}
