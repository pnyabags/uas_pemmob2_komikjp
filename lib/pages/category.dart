import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/category_services.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final TextEditingController _controller = TextEditingController();

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hapus Kategori'),
            content: const Text(
              'Semua komik dalam kategori ini akan dipindahkan ke kategori default',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _addCategory() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    CategoryService.addCategory(text);
    _controller.clear();
  }

  void _editCategory(
    BuildContext context,
    String categoryId,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Kategori'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;

              await CategoryService.updateCategoryName(categoryId, newName);

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori'), centerTitle: false),
      body: Column(
        children: [
          /// INPUT ADD CATEGORY
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Kategori baru',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// REAL-TIME CATEGORY LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: CategoryService.streamCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ReorderableListView.builder(
                  itemCount: docs.length,
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = docs.removeAt(oldIndex);
                    docs.insert(newIndex, item);
                    await CategoryService.updateOrder(docs);
                  },
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isDefault = data['isDefault'] == true;

                    return ListTile(
                      key: ValueKey(docs[index].id),
                      title: Text(data['name']),
                      leading: const Icon(Icons.drag_handle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// EDIT
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: isDefault
                                ? null
                                : () {
                                    _editCategory(
                                      context,
                                      doc.id,
                                      data['name'],
                                    );
                                  },
                          ),

                          /// DELETE
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.redAccent,
                            onPressed: isDefault
                                ? null
                                : () async {
                                    final confirm = await _confirmDelete(
                                      context,
                                    );
                                    if (confirm) {
                                      await CategoryService.deleteCategory(
                                        doc.id,
                                      );
                                    }
                                  },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
