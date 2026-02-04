import 'package:flutter/material.dart';

class FilterKomik extends StatelessWidget {
  const FilterKomik({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Filter & Sort',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ListTile(leading: Icon(Icons.sort_by_alpha), title: Text('Sort A–Z')),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Sort by Latest'),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Filter by Category'),
          ),
        ],
      ),
    );
  }
}
