import 'package:books/domain/entities/book.dart';
import 'package:flutter/material.dart';

class Searchbarwidget extends StatelessWidget {
  List<String> items = [];
  final List<Book> Books;
  final void Function(String query) onSubmit;
  final List<String> _filteredList = [];
  late SearchController _gController;
  late BuildContext _gCotext;

  bool _isPart(String a, String b) {
    int cnt = 0;
    for (int i = 0; i < a.length; i++) {
      if (cnt >= b.length) break;
      if (a[i] == b[cnt]) {
        cnt++;
      } else {
        if (cnt != 0) cnt = 0;
      }
    }
    return (cnt == b.length && cnt != 0);
  }

  void _filterSearch(String value) {
    _filteredList.clear();
    for (final item in items) {
      if (item.length >= value.length &&
          _isPart(item.toLowerCase(), value.toLowerCase())) {
        _filteredList.add(item);
      }
    }
  }

  SearchBar _searchBar(SearchController controller, BuildContext context) {
    _gController = controller;
    controller.addListener(() {
    _filterSearch(controller.text);

final text = controller.text;
if (text.isEmpty) return;

if (_filteredList.isEmpty) {
  _filteredList.add(text);
} else {
  final last = _filteredList.last;
  if (last != text) {
    _filteredList[_filteredList.length - 1] = text;
  }
}

    });
    return SearchBar(
      hintText: "search",
      controller: controller,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.1,
        minHeight: MediaQuery.of(context).size.height / 12,

      ),
      onTap: () {
        controller.openView();
      },
      onChanged: (value) {
        FocusScope.of(context).unfocus();

        controller.openView();
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      leading: Icon(Icons.search),
      onSubmitted: (value) {
        onSubmit(value);
      },
    );
  }

  Widget _filteredListTile(String item, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.search, color: Colors.deepPurple),
        title: Text(item, style: const TextStyle(fontSize: 16)),
        onTap: () {
          _gController.closeView(item);
          FocusScope.of(context).unfocus();
          onSubmit(item);
        },
      ),
    );
  }

  Searchbarwidget({super.key, required this.Books, required this.onSubmit}) {
    for (final book in Books) {
      if(!items.contains(book.author))
      {
        items.add(book.author);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (screenWidth - screenWidth / 1.1) / 2,
        vertical: screenHeight * 0.02,
      ),

      child: SearchAnchor(
        viewOnSubmitted: (value) {
          _gController.closeView(value);
          FocusScope.of(_gCotext).unfocus();
          onSubmit(value);
        },
        builder: (context, controller) {
          return _searchBar(controller, context);
        },
        suggestionsBuilder: (context, controller) {
          _gCotext = context;
          return _filteredList
              .map((item) => _filteredListTile(item, context))
              .toList();
        },
      ),
    );
  }
}
