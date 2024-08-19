import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Define box name as a constant for better maintainability
const String _boxName = 'myBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Open the box here to ensure it's available before the app starts
  await Hive.openBox<int>(_boxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
      ),
      home: const MyHomePage(
          title: 'Hive Demo Page'), // Directly navigate to HomePage
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<int> _box; // No need for nullability here, box is already open

  @override
  void initState() {
    super.initState();
    _box = Hive.box<int>(_boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (kIsWeb)
              const Text('Refresh this tab to test persistence')
            else
              const Text('Restart the app to test persistence'),
            const SizedBox(height: 8),
            const Text('You have pushed the button this many times:'),
            ValueListenableBuilder<Box<int>>(
              valueListenable: _box.listenable(),
              builder: (context, box, _) {
                return Text(
                  '${box.get('counter', defaultValue: 0)}',
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              // Simplify counter update
              int currentCount = _box.get('counter', defaultValue: 0)!;
              _box.put('counter', currentCount - 1);
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            onPressed: () {
              // Simplify counter update
              int currentCount = _box.get('counter', defaultValue: 0)!;
              _box.put('counter', currentCount + 1);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
