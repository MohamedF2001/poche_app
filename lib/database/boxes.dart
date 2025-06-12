import 'package:hive/hive.dart';
import 'package:poche/models/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactionsBox() =>
      Hive.box<Transaction>('transactions');
  static Box getStorageBox() => Hive.box('storage');
}