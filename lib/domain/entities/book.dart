import 'dart:core';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final Uint8List  image; 
  final String title;
  final String author;
  final String summary;

 const Book({
    required this.image,
    required this.title,
    required this.author,
    required this.summary,
  });

  @override
  List<Object?> get props => [image, title, author, summary];
}
