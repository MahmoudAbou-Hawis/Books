import 'package:books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class BookListsWidget extends StatelessWidget {
  final List<Book> Books;
  final ScrollController scrollController = ScrollController();
  final void Function() scroll;

  BookListsWidget({required this.Books, required this.scroll}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        scroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: Books.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Books[index] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            Books[index].image,
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 80),
                          ),
                        )
                      : Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 40),
                        ),
                  const SizedBox(width: 16),

                  // Book Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          Books[index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Authors
                        Text(
                          Books[index].author,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Summary (ReadMoreText)
                        ReadMoreText(
                          Books[index].summary,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'See More',
                          trimExpandedText: 'See Less',
                          colorClickableText: Theme.of(context).primaryColor,
                          style: const TextStyle(fontSize: 14),
                          moreStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          lessStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
