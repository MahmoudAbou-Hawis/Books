import 'package:books/domain/entities/book.dart';
 

abstract class Abstractinternalstorage {
  List<Book> getCashedBooks();
  Future<void> cashBooks(List<Book> postModels); 
}