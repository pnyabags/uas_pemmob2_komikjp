import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/category_services.dart';

class SelectCategory extends StatefulWidget {
  final Function(List<String>) onConfirm;

  const SelectCategory({super.key, required this.onConfirm});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final Set<String> _selected = {};

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
                'Select Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...categories.map((cat) {
                final data = cat.data() as Map<String, dynamic>;
                return CheckboxListTile(
                  title: Text(data['name']),
                  value: _selected.contains(cat.id),
                  onChanged: (val) {
                    setState(() {
                      val == true
                          ? _selected.add(cat.id)
                          : _selected.remove(cat.id);
                    });
                  },
                );
              }),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(_selected.toList());
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
