import 'package:books/core/error/failure.dart';
import 'package:books/domain/entities/book.dart';
import 'package:books/domain/repositories/book_repositiory.dart';
import 'package:dartz/dartz.dart';

class GetBooksUsecase  {
  final BookRepositiory repository;

  GetBooksUsecase(this.repository);

  Future<Either<Failure,List<Book>>> call(bool state) async {
    return await repository.getBooks(state);
  }
}