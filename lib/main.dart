import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dreams notes',
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
  TextEditingController inputDream = new TextEditingController();
  var extendedMood;
  var _currentSliderValue = 0.0;

  String getMood(double currentValue) {
    String mood = "Excellent";
    extendedMood = "++ " + mood;
    if (currentValue < 1.5) {
      mood = "Good";
      extendedMood = "+ " + mood;
    }
    if (currentValue < 0.5) {
      mood = "Neutral";
      extendedMood = "0 " + mood;
    }
    if (currentValue < -0.5) {
      mood = "Bad";
      extendedMood = "- " + mood;
    }
    if (currentValue < -1.5) {
      mood = "NightMare";
      extendedMood = "-- " + mood;
    }
    return mood;
  }

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
            controller: inputDream,
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
          Slider(
            value: _currentSliderValue,
            min: -2,
            max: 2,
            divisions: 4,
            activeColor: Colors.green,
            label: getMood(_currentSliderValue),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                listPage();
              },
              child: Text(
                "List of dreams",
                style: TextStyle(color: Colors.green),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final count = ((prefs.getInt('counter') ?? 0) + 1);
                prefs.setInt('counter', count);
                prefs.setString('dream' + count.toString(), inputDream.text);
                var today = DateTime.now();
                prefs.setString(
                    'date' + count.toString(),
                    (today.year.toString() +
                        "-" +
                        today.month.toString() +
                        "-" +
                        today.day.toString() +
                        " " +
                        today.hour.toString() +
                        ":" +
                        today.minute.toString()));
                prefs.setString('mood' + count.toString(), extendedMood);
                listPage();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.green),
              ),
            )
          ]),
        ]));
  }

  void listPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListOfDreamsPage()),
    );
  }
}

class ListOfDreamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs;
    getValues() async {
      prefs = await SharedPreferences.getInstance();
    }

    getValues();
    return MaterialApp(
      title: 'Dreams notes',
      theme: ThemeData.dark(),
      home: DreamsPage(prefs: prefs),
    );
  }
}

class DreamsPage extends StatefulWidget {
  DreamsPage({Key key, this.prefs}) : super(key: key);
  SharedPreferences prefs;

  @override
  _DreamsPageState createState() => _DreamsPageState();
}

class _DreamsPageState extends State<DreamsPage> {
  @override
  var items = new List<Widget>();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final count = (prefs.getInt('counter')) ?? 0;
      for (int i = 0; i < count; i++) {
        final dream = prefs.getString('dream' + (i + 1).toString()) ?? "";
        final date = prefs.getString('date' + (i + 1).toString()) ?? "";
        final mood = prefs.getString('mood' + (i + 1).toString()) ?? "";

        items.add(Text(date + ' ' + mood));
      }
    });
  }

  Widget build(BuildContext context) {
    return Material(
      child: Column(children: items),
    );
  }
}
