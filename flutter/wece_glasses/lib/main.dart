import 'package:flutter/material.dart';
import 'theme.dart';
import 'constants.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  final flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> deviceList = [];
  BluetoothDevice? connectedDevice;
  String dropdownValue = 'One';

  @override
  void initState() {
    flutterBlue.startScan();
    List<BluetoothDevice> temp = [];
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
          for (BluetoothDevice device in devices) {
            if(!temp.contains(device)) {
              temp.add(device);
            }
          }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if(!temp.contains(result.device)) {
          temp.add(result.device);
        }
      }
    });
    setState(() {
      deviceList = temp;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("There are " + deviceList.length.toString() + " devices connected."),
            DropdownButton(
              value: connectedDevice,
              onChanged: (BluetoothDevice? newValue) {
                setState(() {
                  connectedDevice = newValue!;
                });
              },
              items: deviceList
                  .map<DropdownMenuItem<BluetoothDevice>>((BluetoothDevice value) {
                return DropdownMenuItem<BluetoothDevice>(
                  value: value,
                  child: Text(value.name + " " + value.id.toString()),
                );
              }).toList(),
            ),
            DropdownButton(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
