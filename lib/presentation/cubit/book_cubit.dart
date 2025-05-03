import 'package:books/core/error/failure.dart';
import 'package:books/domain/entities/book.dart';
import 'package:books/domain/usecasses/getBooks.dart';
import 'package:books/domain/usecasses/search.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final GetBooksUsecase GetBooks;
  final SearchBooksUsecase SearchBooks;
  List<Book> defaultBookList = [];
  BookCubit(this.GetBooks, this.SearchBooks) : super(InitState([]));

  loadBooks() async {
    emit(LoadingBooks(state.Books));

    final result = await GetBooks.call(false);

    final newState = _mapFailureOrBooksToState(result, state.Books);
    if (newState is LoaddedBooks && defaultBookList.isEmpty) {
      defaultBookList.addAll(newState.Books);
    }
    emit(newState);
  }

  getMoreBooks() async {
    final result = await GetBooks.call(true);
    emit(_mapFailureOrGetMoreBooksToState(result, state.Books));
  }

  searchForaBook(String name) async {
    emit(LoadingBooks(state.Books));
    if (name.isNotEmpty) {
      final result = await SearchBooks.call(name, state.Books);
      emit(_mapSearchFailure(result, state.Books));
    } else {
      final result = await GetBooks.call(true);

      emit(LoaddedBooks(defaultBookList));
    }
  }

  LoadMoreSearchBooks(String name) async {
    final result = await SearchBooks.call(name, state.Books);
    emit(_mapSearchMoreFailure(result, state.Books));
  }

  BookState _mapSearchMoreFailure(
    Either<Failure, List<Book>> either,
    List<Book> current,
  ) {
    return either.fold(
      (failure) => ErrorSearchingBookState(
        current,
        _mapSearchingFailureToMessage(failure),
      ),
      (Books) => GettingMoreSearchingBooksState([
        ...current,
        ...Books,
      ], (state as SearchingState).searchedList),
    );
  }

  BookState _mapSearchFailure(
    Either<Failure, List<Book>> either,
    List<Book> current,
  ) {
    return either.fold(
      (failure) => ErrorSearchingBookState(
        current,
        _mapSearchingFailureToMessage(failure),
      ),
      (books) => SearchingState(books, [...books, ...state.Books]),
    );
  }

  BookState _mapFailureOrBooksToState(
    Either<Failure, List<Book>> either,
    List<Book> current,
  ) {
    return either.fold(
      (failure) => ErrorBooksState(current, _mapFailureToMessage(failure)),
      (posts) => LoaddedBooks(posts),
    );
  }

  BookState _mapFailureOrGetMoreBooksToState(
    Either<Failure, List<Book>> either,
    List<Book> current,
  ) {
    return either.fold(
      (failure) => ErrorGettingMoreBooksState(
        current,
        _mapGettingMoreBooksFailureToMessage(failure),
      ),
      (Books) => GettingMoreBooksState([...current, ...Books]),
    );
  }

  String _mapGettingMoreBooksFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "internet connection is Lost";
      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Try to open the app later";
      case EmptyCacheFailure:
        return "Please Reconnect To the internet";
      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  String _mapSearchingFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Try to open the app later";
      case NotFoundFailure:
        return "Not Found any Books";
      case NoSearchMore:
        return "Not Found more Books";
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
