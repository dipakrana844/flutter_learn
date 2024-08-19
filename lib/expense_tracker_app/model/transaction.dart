import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  DateTime? createdDate;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late bool isExpense;

  Transaction({
    this.name = "",
    this.createdDate,
    this.amount = 0.0,
    this.isExpense = true,
  });
}
