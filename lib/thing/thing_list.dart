import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stuffd/helpers/loader.dart';

import 'package:stuffd/thing/thing.dart';
import 'package:stuffd/thing/thing_form.dart';
import 'package:stuffd/thing/thing_upc.dart';
import 'package:stuffd/utils/database_manager.dart';

class ThingList extends StatefulWidget {
  @override
  _ThingListState createState() => _ThingListState();
}

class _ThingListState extends State<ThingList> {
  List<Thing> _things = List.empty();
  bool isLoading = false;
  var db = DatabaseManager.instance;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    refreshThings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusDetector(
          onVisibilityGained: () {
            //if (!isLoading) refreshThings();
          },
          child: new Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  refreshThings(q: value);
                },
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(LineAwesomeIcons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    )),
              ),
            ),
            Expanded(child: _buildList()),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ThingUPC(),
          ));
        refreshThings();
        },
        backgroundColor: NordColors.aurora.purple,

        
        child: const Icon(LineAwesomeIcons.plus, color: NordColors.$0, size:40),
      ),
    );
  }

  Future refreshThings({String? q}) async {
    setState(() => isLoading = true);
    if (q == null || q.isEmpty)
      this._things = await db.getThings();
    else
      this._things = await db.getThings(q: q);

    setState(() => isLoading = false);
  }

  Widget _buildList() {
    if (!isLoading && _things.isNotEmpty) {
      return ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: _things.length * 2,
          itemBuilder: (BuildContext _context, int i) {
            if (i.isOdd) {
              return Divider();
            }

            int index = i ~/ 2;
            if (index < _things.length)
              return _buildRow(_things[index]);
            else
              return Divider();
          });
    }
    else if(_things.isNotEmpty){
      return Loader();
    }
     else {
      return Center(
        child: Text("Where's my stuff!"),
      );
    }
  }

  Widget _buildRow(Thing t) {
    return ListTile(
      title: Text(
        t.name,
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ThingForm(
            thing: t,
          ),
        ));
       refreshThings();
      },
    );
  }
}
