part of 'book_cubit.dart';

sealed class BookState extends Equatable {
  final List<Book> Books;

  BookState(this.Books);

  @override
  List<Object?> get props => [Books];
}

class InitState extends BookState {
  InitState(super.Books);
}

class LoadingBooks extends BookState {
  LoadingBooks(super.Books);
}

class LoaddedBooks extends BookState {
  LoaddedBooks(super.Books);
}

class SearchingState extends BookState {
  List<Book> searchedList;
  SearchingState(super.Books,this.searchedList);
}

class ErrorBooksState extends BookState {
  final String message;
  ErrorBooksState(super.Books, this.message);
}

class GettingMoreBooksState extends BookState {
  GettingMoreBooksState(super.Books);
}

class GettingMoreSearchingBooksState extends SearchingState {
  GettingMoreSearchingBooksState(super.Books,super.searchedList);
}

class ErrorGettingMoreBooksState extends BookState {
  final String message;
  ErrorGettingMoreBooksState(super.Books, this.message);
}

class ErrorSearchingBookState extends BookState {
  final String message;
  ErrorSearchingBookState(super.Books, this.message);
}
