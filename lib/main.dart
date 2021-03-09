import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
        body: ListView(shrinkWrap: true, children: [
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
                save();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewDreamPage(title: 'New Dream')),
                );
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
                save();
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

  void save() async {
    //final count = ((prefs.getInt('counter') ?? 0) + 1);
    var today = DateTime.now();
    String date = (today.year.toString() +
        "-" +
        today.month.toString().padLeft(2, '0') +
        "-" +
        today.day.toString().padLeft(2, '0') +
        " " +
        today.hour.toString().padLeft(2, '0') +
        ":" +
        today.minute.toString().padLeft(2, '0'));
    String csvRows = "";
    content += setCSV(date, extendedMood, inputDream.text);
    await saveFile(content);
  }
}

class ListOfDreamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getValues() async {
      String result = await readFile();
    }

    getValues();

    return MaterialApp(
      title: 'Dreams notes',
      theme: ThemeData.dark(),
      home: DreamsPage(),
    );
  }
}

class DreamsPage extends StatefulWidget {
  DreamsPage({Key key}) : super(key: key);

  @override
  _DreamsPageState createState() => _DreamsPageState();
}

class _DreamsPageState extends State<DreamsPage> {
  @override
  var items = new List<TableRow>();

  @override
  void initState() {
    super.initState();
    if (content == null) return;
    List<String> rows = content.split("\r\n");
    final counter = rows == null ? 0 : rows.length;
    for (int i = 0; i < counter - 1; i++) {
      List<String> it = rows[i].split(',');

      String date = it[0];
      String mood = it[1];
      String dream = rows[i].replaceFirst(date + "," + mood + ",", '');

      TableRow tr = TableRow(children: [
        Text(date),
        Text(mood),
        OutlineButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailDreamPage(
                      title: 'Detail Dream',
                      dream: dream,
                      date: date,
                      mood: mood)),
            );
          },
          child: Text(
            "Detail",
            style: TextStyle(color: Colors.green),
          ),
          borderSide: BorderSide(
              color: Colors.green, width: 1, style: BorderStyle.solid),
          hoverColor: Colors.green,
          focusColor: Colors.green,
        ),
      ]);
      items.add(tr);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'List of your dreams:',
          style: TextStyle(color: Colors.green),
        )),
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20,
            ),
            Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(
                  horizontalInside: BorderSide(width: 1, color: Colors.green),
                ),
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: items),
            Column(
              /*
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              */
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlineButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewDreamPage(title: 'New Dream')),
                    );
                  },
                  child: Text(
                    "New dream",
                    style: TextStyle(color: Colors.green),
                  ),
                  borderSide: BorderSide(
                      color: Colors.green, width: 2, style: BorderStyle.solid),
                  hoverColor: Colors.green,
                  focusColor: Colors.green,
                )
              ],
            )
          ],
        ));
  }
}

class DetailDreamPage extends StatefulWidget {
  DetailDreamPage({Key key, this.title, this.dream, this.date, this.mood})
      : super(key: key);
  final String title;
  final String dream;
  final String date;
  final String mood;

  @override
  _DetailDreamPage createState() => _DetailDreamPage();
}

class _DetailDreamPage extends State<DetailDreamPage> {
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
      body: ListView(
        children: [
          Text(widget.dream,
              style: TextStyle(color: Colors.green, fontSize: 25)),
          SizedBox(height: 60),
          Row(children: [
            Text(widget.mood,
                style: TextStyle(color: Colors.green, fontSize: 15)),
            SizedBox(width: 60),
            Text(widget.date,
                style: TextStyle(color: Colors.green, fontSize: 15))
          ])
        ],
        shrinkWrap: true,
      ),
    );
  }
}

String setCSV(String date, String mood, String dream) {
  String rowString = "";
  rowString += "" +
      date +
      "," +
      mood +
      "," +
      dream +
      "\r\n";
  return rowString;
}
/*
Future<String> getFilePath() async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/dreamsRecords.txt'; // 3

  return filePath;
}*/


void saveFile(String text) async {
  var file = File('/storage/emulated/0/Android/data/cz.bassnick.dr_ea_ms/exp.txt'); // 1
  var sink = file.openWrite(); // 2
  sink.write(text);
  await sink.flush();
  await sink.close();
}

Future readFile() async {
  File file = File('/storage/emulated/0/Android/data/cz.bassnick.dr_ea_ms/exp.txt'); // 1
  content = await file.readAsString(); // 2
  print(content);
}

String content = "";

