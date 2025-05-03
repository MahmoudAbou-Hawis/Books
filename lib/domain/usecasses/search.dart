import 'package:books/core/error/failure.dart';
import 'package:books/domain/entities/book.dart';
import 'package:books/domain/repositories/book_repositiory.dart';
import 'package:dartz/dartz.dart';

class SearchBooksUsecase {
  final BookRepositiory repository;

  SearchBooksUsecase(this.repository);

  Future<Either<Failure,List<Book>>> call(String name ,List<Book> books) async {
    return await repository.searchBook(name,books);
  }
}