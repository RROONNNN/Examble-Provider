import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      create: (context) => ProviderObject(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("build in myhomepage");

    return Scaffold(
        appBar: AppBar(title: Text("Demo Provider part 2")),
        body: Column(
          children: [
            Row(
              children: [ExpensiveContainer(), CheapContainer()],
            ),
            TextButton(
                onPressed: () {
                  var provider = context.read<ProviderObject>();
                  provider.start();
                },
                child: Text("Start")),
            TextButton(
                onPressed: () {
                  var provider = context.read<ProviderObject>();
                  provider.stop();
                },
                child: Text("Stop")),
          ],
        ));
  }
}

class ExpensiveContainer extends StatelessWidget {
  const ExpensiveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    print("build in Expensive");
    var provider = context.select<ProviderObject, ExpensiveObject>(
        (provider) => provider.expensiveObject);
    return Container(
      color: Colors.amber,
      height: 100,
      child: Column(children: [
        Text("Expensive Widget"),
        Text("Last updated"),
        Text(provider.datetime)
      ]),
    );
  }
}

class CheapContainer extends StatelessWidget {
  const CheapContainer({super.key});

  @override
  Widget build(BuildContext context) {
    print("build in cheap");
    var provider = context.select<ProviderObject, CheapObject>(
        (provider) => provider.cheapObject);
    return Container(
      color: Colors.blue,
      height: 100,
      child: Column(children: [
        Text("Cheap Widget"),
        Text("Last updated"),
        Text(provider.datetime)
      ]),
    );
  }
}

class ExpensiveObject {
  String datetime;
  ExpensiveObject() : datetime = DateTime.now().toIso8601String();
}

class CheapObject {
  String datetime;
  CheapObject() : datetime = DateTime.now().toIso8601String();
}

class ProviderObject extends ChangeNotifier {
  late ExpensiveObject expensiveObject;
  late CheapObject cheapObject;
  late StreamSubscription _expensive;
  late StreamSubscription _cheap;
  ProviderObject() {
    expensiveObject = ExpensiveObject();
    cheapObject = CheapObject();
  }
  void start() {
    _expensive = Stream.periodic(
      const Duration(seconds: 2),
    ).listen((event) {
      expensiveObject = ExpensiveObject();
      notifyListeners();
    });
    _cheap = Stream.periodic(
      const Duration(seconds: 1),
    ).listen((event) {
      cheapObject = CheapObject();
      notifyListeners();
    });
  }

  void stop() {
    _expensive.cancel();
    _cheap.cancel();
  }
}

class ProviderWidget extends ChangeNotifierProvider<ProviderObject> {
  Key? key;
  Widget? child;
  ProviderWidget({Key? key, required Widget child, required super.create})
      : super(key: key, child: child);
}
