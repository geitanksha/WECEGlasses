import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Color buttonColor = Color.grey;
  bool buttonOn = false
  @override
  Widget build(BuildContext context) {
    //final ButtonStyle style =
    //ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));


    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            child: Text('Elevated Button'),
            style: ElevatedButton.styleFrom(
                primary: ButtonOn ? Colors.green : Colors.red;
                elevation: 8,
                shape: CircleBorder(),
                minimumSize: Size.square(80)
            ),
            onPressed: () {
              setState(){
                if buttonOn == true{
                buttonOn  = false;
                }
                else{
                buttonOn  = true;
                }
                }
              print('Pressed');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(

                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) return Colors.blue;
                  return Colors.grey;
                },
              ),
            ),
          )

        ],
      ),
    );
  }
}
