import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'theme.dart';
import 'constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The app theme is defined in constants.dart
      title: Constants.appName,
      // The app theme is defined in theme.dart
      theme: AppTheme,
      // This directs the app to start at the screen class called MyHomePage.
      // Currently the main screen is the default from Flutter, but we will
      // edit the screens and screen routes as needed.
      home: const MyHomePage(title: Constants.appName),
    );
  }
}

// This is the default home page defined by Flutter. In the future,
// this will be moved out of main.dart for better organization.
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _connectedDevice = ""; // Default no device selected

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      // Set of widgets will be arranged vertically
      body: Column(
        children: <Widget>[
          // Widgets will be arranged horizontally
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Connected Device: ',
              ),
              DropdownButton<String>(
                value: _connectedDevice,
                icon: const Icon(Icons.beach_access),
                iconSize: 15,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent, // TODO change to theme
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _connectedDevice = newValue!;
                  });
                },
                // This is an example list of items.
                // We will need to generate this list programmatically
                items: <String>['', 'Device 1', 'Device 2', 'Device 3', 'Device 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          // TODO add screen management buttons
        ],
      ),
    );
  }
}
