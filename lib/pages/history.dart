import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement refresh functionality here
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Riwayat Konten akan ditampilkan di sini'),
      ),
    );
  }
}
