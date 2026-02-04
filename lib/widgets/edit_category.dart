import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/category_services.dart';
import '../services/library_services.dart';

class EditCategory extends StatefulWidget {
  final String comicId;
  final List<String> currentCategories;

  const EditCategory({
    super.key,
    required this.comicId,
    required this.currentCategories,
  });

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late Set<String> selected;

  @override
  void initState() {
    super.initState();
    selected = widget.currentCategories.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot>(
        stream: CategoryService.streamCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!.docs;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...categories.map((cat) {
                final data = cat.data() as Map<String, dynamic>;
                return CheckboxListTile(
                  title: Text(data['name']),
                  value: selected.contains(cat.id),
                  onChanged: (val) {
                    setState(() {
                      val == true
                          ? selected.add(cat.id)
                          : selected.remove(cat.id);
                    });
                  },
                );
              }),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await LibraryService.updateCategories(
                      widget.comicId,
                      selected.toList(),
                    );
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
