import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/transaction.dart';
import 'page/transaction_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  try {
    await Hive.openBox<Transaction>('transactions');
  } catch (e) {
    // Handle the error, e.g., log it or display an error message
    print('Error opening Hive box: $e');
  }

  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  static const String title = 'Hive Expense App';
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TransactionPage(),
    );
  }
}
