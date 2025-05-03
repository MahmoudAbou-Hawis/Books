import 'package:books/domain/entities/book.dart';
import 'package:hive/hive.dart';

class BookAdapter extends TypeAdapter<Book> {
  @override
  int get typeId => 0;

  @override
  Book read(BinaryReader reader) {
    return Book(author: reader.readString() , title:reader.readString(),summary: reader.readString() ,image: reader.readByteList());
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer.writeString(obj.author);
    writer.writeString(obj.title);
    writer.writeString(obj.summary);
    writer.writeByteList(obj.image);
  }
}
