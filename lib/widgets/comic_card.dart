import 'package:flutter/material.dart';
import '../models/model_comic.dart';
import '../pages/comic_detail.dart';

class ComicCard extends StatelessWidget {
  final Comic comic;

  const ComicCard({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ComicDetail(comic: comic)),
        );
      },
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// COVER IMAGE (ASSET / NETWORK)
              Image(
                image: comic.cover.startsWith('http')
                    ? NetworkImage(comic.cover)
                    : AssetImage(comic.cover) as ImageProvider,
                fit: BoxFit.cover,
              ),

              /// UNREAD BADGE
              if (comic.unreadCount > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _badge(
                    text: '${comic.unreadCount} unread',
                    color: Colors.redAccent,
                  ),
                ),

              /// LAST READ CHAPTER
              Positioned(
                top: 8,
                right: 8,
                child: _badge(
                  text: 'Ch. ${comic.lastReadChapter}',
                  color: Colors.blueAccent,
                ),
              ),

              /// TITLE OVERLAY
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Text(
                  comic.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// BADGE WIDGET
Widget _badge({required String text, required Color color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
