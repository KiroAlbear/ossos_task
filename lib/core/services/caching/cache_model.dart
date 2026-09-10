import 'package:drift/drift.dart';

@DataClassName('CacheEntry')
class Cache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  TextColumn get response => text()();
  DateTimeColumn get expiration => dateTime()();
}
