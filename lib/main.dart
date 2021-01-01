import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: NewDreamPage(title: 'New Dream'),
    );
  }
}

class NewDreamPage extends StatefulWidget {
  NewDreamPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewDreamPageState createState() => _NewDreamPageState();
}

class _NewDreamPageState extends State<NewDreamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.green),
          ),
        ),
        body: Column(children: [
          TextField(
            style: TextStyle(color: Colors.white38),
            cursorColor: Colors.white38,
            keyboardType: TextInputType.multiline,
            maxLength: null,
            maxLines: null,
            autofocus: true,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 4.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
                hintText: 'Enter the dream'),
          ),
              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    OutlinedButton(

              onPressed: () {
                // Respond to button press
              },
              child: Text(
                "Next dream",
                style: TextStyle(color: Colors.green),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Respond to button press
              },
              child: Text(
                "List of dreams",
                style: TextStyle(color: Colors.green),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Respond to button press
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.green),
              ),
            )
          ]),
        ]));
  }
}
