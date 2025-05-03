import 'dart:math';

import 'package:books/core/error/exceptions.dart';
import 'package:books/core/error/failure.dart';
import 'package:books/core/network/network_info.dart';
import 'package:books/data/datasource/interfaces/abstractInternalStorage.dart';
import 'package:books/data/datasource/interfaces/abstractapicalling.dart';
import 'package:books/domain/entities/book.dart';
import 'package:books/domain/repositories/book_repositiory.dart';
import 'package:dartz/dartz.dart';

class Bookrepositoryimpl extends BookRepositiory {
  final Abstractinternalstorage _localDataSource;
  final AbstractBookApi _remoteDataSource;
  final NetworkInfo _networkInfo;
  late List<Book> _currentList;

  Bookrepositoryimpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  Future<List<Book>> _getBufferedBooks() async {
    List<Book> list = [];
    int len = _currentList.length;
    for (int _current = 0; _current < min(10, len); _current++) {
      list.add(_currentList[_currentList.length - 1]);
      _currentList.removeLast();
    }
    await _localDataSource.cashBooks(list);
    return list;
  }

  @override
  Future<Either<Failure, List<Book>>> getBooks(bool state) async {
    if (await _networkInfo.isConnected) {
      try {
        final books = await _remoteDataSource.getNextBooks();
        _localDataSource.cashBooks(books);
        return Right(books);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      if (!state) {
        try {
          final cashedBooks = _localDataSource.getCashedBooks();
          return Right(cashedBooks);
        } on EmptyCacheException {
          return Left(EmptyCacheFailure());
        }
      } else {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Book>>> searchBook(
    String name,
    List<Book> books,
  ) async {
    if (await _networkInfo.isConnected) {
      if (name != '') {
        try {
          _currentList = await _remoteDataSource.searchBook(name);
          return Right(await _getBufferedBooks());
        } on NotFoundException {
          return Left(NotFoundFailure());
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        if (_currentList.isEmpty) {
          return Left(NoSearchMore());
        } else {
          return Right(await _getBufferedBooks());
        }
      }
    } else {
      List<Book> filtered = [];

      for (final book in books) {
        if (book.author.contains(name) || book.title.contains(name)) {
          filtered.add(book);
        }
      }
      int cnt = 0;
      for (int i = 0; i < filtered.length; i++) {
        if (filtered[i].author == books[i].author &&
            filtered[i].title == books[i].title &&
            filtered[i].summary == books[i].summary) {
          cnt++;
        }
      }
      if (cnt == books.length) {
        return Left(NoSearchMore());
      }
      if (filtered.isEmpty) {
        return Left(NotFoundFailure());
      } else {
        return Right(filtered);
      }
    }
  }
}
