import 'package:books/data/models/bookModel.dart';

abstract class AbstractBookApi {
  Future<List<BookModel>> getNextBooks();
  Future<List<BookModel>> searchBook(String Name);
}
