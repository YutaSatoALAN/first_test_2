import 'package:first_test_2/finger_tapping.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('評価List'),
        backgroundColor: Colors.teal,
      ),
      body: BuildList(),
    );
  }
}

class BuildList extends StatefulWidget {
  @override
  _BuildListState createState() => _BuildListState();
}

class _BuildListState extends State<BuildList> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Card(
        color: Colors.white60,
        child: ListTile(
          title: Text(
            '指タッピング',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FingerTapping(),
              ),
            );
          },
        ),
      ),
      Card(
        color: Colors.white60,
        child: ListTile(
          title: Text(
            '脚タッピング',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FingerTapping(),
              ),
            );
          },
        ),
      ),
      Card(
        color: Colors.white60,
        child: ListTile(
          title: Text(
            '歩行',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FingerTapping(),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
