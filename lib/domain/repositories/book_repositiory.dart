import 'package:books/core/error/failure.dart';
import 'package:books/domain/entities/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepositiory {
  Future<Either<Failure, List<Book>>> getBooks(bool state);
  Future<Either<Failure, List<Book>>> searchBook(String name,List<Book> books);
}
