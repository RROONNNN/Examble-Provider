import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("build in MyAppp\n");
    return BreadCrumbProvider(
      create: (context) => BreadCrumbNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/Addscreen': (BuildContext context) => Addscreen(),
        },
      ),
    );
  }
}

class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("build in _AddscreenState\n");

    return Scaffold(
        appBar: AppBar(
          title: Text("AddScreen"),
        ),
        body: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Add name"),
            ),
            TextButton(
                onPressed: () {
                  var r = context.read<BreadCrumbNotifier>();
                  r.add(breadcrumb: breadcrumb(name: _controller.text));
                  Navigator.of(context).pop();
                },
                child: Text("ADD"))
          ],
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("build in homepage=\n");

    return Scaffold(
        appBar: AppBar(
          title: Text(" ProviderDemo"),
        ),
        body: Column(
          children: [
            Consumer<BreadCrumbNotifier>(builder: (context, abc, child) {
              return Wrap(
                children: abc._breadcrumbs.map((e) {
                  String extra = (e._isActive) ? ">" : "";
                  return Text(e.name + extra);
                }).toList(),
              );
            }),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/Addscreen");
                },
                child: Text("Add")),
            TextButton(onPressed: () {}, child: Text("Reset")),
          ],
        ));
  }
}

class breadcrumb {
  final String name;
  bool _isActive = false;
  breadcrumb({required this.name});
}

class BreadCrumbNotifier extends ChangeNotifier {
  List<breadcrumb> _breadcrumbs = [];
  UnmodifiableListView<String> get breadcrumbs =>
      _breadcrumbs as UnmodifiableListView<String>;
  void add({required breadcrumb breadcrumb}) {
    if (_breadcrumbs.isEmpty) {
      _breadcrumbs.add(breadcrumb);
    } else {
      _breadcrumbs[_breadcrumbs.length - 1]._isActive = true;
      _breadcrumbs.add(breadcrumb);
    }
    notifyListeners();
  }
}

class BreadCrumbProvider extends ChangeNotifierProvider<BreadCrumbNotifier> {
  Key? key;
  Widget? child;
  BreadCrumbProvider({Key? key, required super.create, required this.child})
      : super(key: key, child: child);
}
