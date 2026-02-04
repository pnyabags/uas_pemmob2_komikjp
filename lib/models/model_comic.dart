class Comic {
  final String id;
  final String title;
  final String cover;
  final String synopsis;
  final String author;
  final String artist;
  final String status;
  final int unreadCount;
  final int lastReadChapter;
  final List<int> chapters;

  Comic({
    required this.id,
    required this.title,
    required this.cover,
    required this.synopsis,
    required this.author,
    required this.artist,
    required this.status,
    required this.unreadCount,
    required this.lastReadChapter,
    required this.chapters,
  });

  factory Comic.fromLibrary(String id, Map<String, dynamic> data) {
    return Comic(
      id: id,
      title: data['title'] ?? 'Untitled',
      cover: data['cover'] ?? '',
      synopsis: '',
      author: '',
      artist: '',
      status: '',
      unreadCount: 0,
      lastReadChapter: 0,
      chapters: const [],
    );
  }
}
