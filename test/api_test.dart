import 'package:books/data/datasource/DioBookApi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:books/data/models/bookModel.dart';

void main() {
  late DioBookApi api;

  setUp(() {
    api = DioBookApi(); // Use real Dio instance inside
  });

  test('fetch books from real server', () async {
    final books = await api.getNextBooks();
    final books2 = await api.getNextBooks();
    final books3 = await api.searchBook('Charles Dickens');
    expect(books[0].author, 'Unknown author');
    expect(books2[0].author, 'Carroll, Lewis');
    expect(books3.isEmpty, false);
  });
}
