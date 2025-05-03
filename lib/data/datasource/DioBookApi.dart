import 'dart:typed_data';

import 'package:books/core/error/exceptions.dart';
import 'package:books/core/error/failure.dart';
import 'package:books/data/datasource/interfaces/abstractapicalling.dart';
import 'package:books/data/models/bookModel.dart';
import 'package:dio/dio.dart';
import 'core/urlBuilder.dart';

class BookData {
  String title;
  String summary;
  String author;
  String? image;
  BookData({
    required this.title,
    required this.summary,
    required this.author,
    required this.image,
  });
}

class DioBookApi extends AbstractBookApi {
  final _dio = Dio();
  int _count = 1;
  int _FetchedBookCount = 10;

  Future<List<BookModel>> extractBookInfo(Map<String, dynamic> data) async {
    final books = data['results'] as List<dynamic>;
    List<BookModel> booksData = [];
    if (data['count'] == 0) return [];
    for (final book in books) {
      final title = book['title'];
      final summary =
          (book['summaries'] as List).isNotEmpty
              ? book['summaries'][0]
              : 'No summary';
      final author =
          (book['authors'] as List).isNotEmpty
              ? book['authors'][0]['name']
              : 'Unknown author';
      final formats = book['formats'] as Map<String, dynamic>;
      final imageLink = formats['image/jpeg'] as String?;

      try {
        Response<List<int>>? image;
        if (imageLink!.isNotEmpty) {
          image = await _dio.get<List<int>>(
            imageLink,
            options: Options(responseType: ResponseType.bytes),
          );
        }

        booksData.add(
          BookModel(
            author: author,
            title: title,
            image: Uint8List.fromList(image?.data ?? []),
            summary: summary,
          ),
        );
      } catch (_) {
        throw EmptyCacheException();
      }
    }

    return booksData;
  }

  String _getBookUri() {
    UriBuilder _builder = UriBuilder("https://gutendex.com");
    String value = _count.toString();
    for (int i = 1; i < _FetchedBookCount; i++) {
      _count++;
      value += ',';
      value += _count.toString();
    }
    _count++;
    _builder.addPath("books");
    _builder.addQuery("ids", value);
    return _builder.build();
  }

  @override
  Future<List<BookModel>> getNextBooks() async {
    try {
      String url = _getBookUri();
      final Response = await _dio.get(url);
      final json = Response.data;
      return await extractBookInfo(json);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<BookModel>> searchBook(String Name) async {
    UriBuilder builder = UriBuilder("https://gutendex.com");
    String url = builder.addPath("books").addQuery('search', Name).build();
    try {
      final Response = await _dio.get(url);
      final json = Response.data;
      final data = await extractBookInfo(json);
      if (data.isEmpty) {
        throw NotFoundException();
      } else {
        return data;
      }
    } on NotFoundException {
      throw NotFoundException();
    } catch (_) {
      throw ServerException();
    }
  }
}
