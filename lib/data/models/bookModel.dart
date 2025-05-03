import 'package:books/domain/entities/book.dart';

class BookModel extends Book {
  // Constructor
  BookModel({
    required super.image,
    required super.title,
    required super.author,
    required super.summary,
  });


  Map<String, dynamic> toJson() {
    return {
      'image': image ?? [],
      'title': title,
      'author': author,
      'summary': summary,
    };
  }
}
