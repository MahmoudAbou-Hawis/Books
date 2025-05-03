import 'package:books/core/network/network_info.dart';
import 'package:books/data/models/bookAdapter.dart';
import 'package:books/domain/entities/book.dart';
import 'package:books/domain/repositories/book_repositiory.dart';
import 'package:books/domain/usecasses/getBooks.dart';
import 'package:books/presentation/cubit/book_cubit.dart';
import 'package:books/presentation/pages/Books_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:books/domain/usecasses/getBooks.dart';
import 'package:books/domain/usecasses/search.dart';
import 'package:books/data/repositories/bookRepositoryImpl.dart';
import 'package:books/data/datasource/DioBookApi.dart';
import 'package:books/data/datasource/hivestorage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  Box<Book> box = await Hive.openBox<Book>('Posts');

  runApp(MyApp(box: box));
}

class MyApp extends StatelessWidget {
  Box<Book> box;
  MyApp({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => BookCubit(
            GetBooksUsecase(
              Bookrepositoryimpl(
                Hivestorage(box),
                DioBookApi(),
                NetworkInfoImpl(InternetConnectionChecker()),
              ),
            ),
            SearchBooksUsecase(
              Bookrepositoryimpl(
                Hivestorage(box),
                DioBookApi(),
                NetworkInfoImpl(InternetConnectionChecker()),
              ),
            ),
          )..loadBooks(),
      child: MaterialApp(debugShowCheckedModeBanner: false
      ,
      title: 'Books',
      home: BookPage(),),
    
    );
  }
}
