import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books/presentation/cubit/book_cubit.dart';
import 'package:books/presentation/widgets/booksListWidget.dart';
import 'package:books/presentation/widgets/loadingWidget.dart';
import 'package:books/presentation/widgets/msgdisplatWidget.dart';
import 'package:books/presentation/widgets/searchbarWidget.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: BlocBuilder<BookCubit, BookState>(
        builder: (context, state) {
          if (state is LoaddedBooks ||
              state is SearchingState ||
              state is GettingMoreBooksState ||
              state is ErrorGettingMoreBooksState ||
              state is GettingMoreSearchingBooksState ||
              state is ErrorSearchingBookState) {
            if (state is ErrorSearchingBookState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              });
            }
            if (state is ErrorGettingMoreBooksState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              });
            }
            if (state is GettingMoreBooksState ||
                state is GettingMoreSearchingBooksState) {}
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Searchbarwidget(
                  Books:
                      (state is SearchingState)
                          ? state.searchedList
                          : state.Books,
                  onSubmit: (query) {
                    context.read<BookCubit>().searchForaBook(query);
                  },
                ),
                Expanded(
                  child: BookListsWidget(
                    Books: state.Books,
                    scroll: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (ScaffoldMessenger.of(context).mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Loading...')));
                        }
                      });
                      if (state is SearchingState ||
                          state is GettingMoreSearchingBooksState ||
                          state is ErrorSearchingBookState) {
                        context.read<BookCubit>().LoadMoreSearchBooks('');
                      } else {
                        context.read<BookCubit>().getMoreBooks();
                      }
                    },
                  ),
                ),
              ],
            );
          } else if (state is ErrorBooksState) {
            return Msgdisplatwidget(msg: state.message);
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}
