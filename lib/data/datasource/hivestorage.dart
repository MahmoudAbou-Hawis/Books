import 'package:books/core/error/exceptions.dart';
import 'package:books/data/datasource/interfaces/abstractInternalStorage.dart';
import 'package:books/domain/entities/book.dart';
import 'package:hive/hive.dart';

class Hivestorage extends Abstractinternalstorage{
  final Box<Book> _box;

  Hivestorage(this._box);
  @override
  Future<void> cashBooks(List<Book> books) async{
    for (final book in books) {
      await _box.put(book.hashCode.toString(), book);
    }
  }

  @override
  List<Book> getCashedBooks() {
  List<Book> cashedBooks = _box.values.toList();
    if (!cashedBooks.isEmpty) {
      return cashedBooks;
    } else {
      throw EmptyCacheException();
    }
  }

}