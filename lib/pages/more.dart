import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'category.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            /// PROFILE
            Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    'assets/images/profile_dummy.png',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Guest User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            /// SECTION LIST
            ListTile(
              leading: Icon(Icons.download),
              title: Text('Unduhan Komik Offline'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Kategori'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Category()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),

            const Divider(),
            const Spacer(),

            /// ABOUT APP
            Column(
              children: const [
                Text(
                  'KomikJP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Tempat Para Komik Nongkrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Dibuat oleh Bagas, Benedictus, and Gens',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
