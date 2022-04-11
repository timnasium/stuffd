import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stuffd/location/location.dart';
import 'package:stuffd/location/location_form.dart';

import 'package:stuffd/utils/database_manager.dart';

class LocationList extends StatefulWidget {
  @override
  _LocationListState createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  late List<Location> _locations;
  bool isLoading = false;
  var db = DatabaseManager.instance;
  @override
  void initState() {
    super.initState();
    refreshLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Column(children: <Widget>[
        Expanded(child: _buildList()),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LocationForm(),
          ));
          refreshLocations();
        },
        backgroundColor: NordColors.aurora.purple,
        child: const Icon(
          LineAwesomeIcons.plus,
          color: NordColors.$0, size:40,
          
        ),
      ),
    );
  }

  Future refreshLocations() async {
    setState(() => isLoading = true);
    this._locations = await db.getLocations();
    setState(() => isLoading = false);
  }

  Widget _buildList() {
    if (!isLoading && _locations.isNotEmpty) {
      return ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: _locations.length * 2,
          itemBuilder: (BuildContext _context, int i) {
            if (i.isOdd) {
              return Divider();
            }

            int index = i ~/ 2;
            if (index < _locations.length)
              return _buildRow(_locations[index]);
            else
              return Divider();
          });
    } else {
      return Center(
        child: Text("No where to go?"),
      );
    }
  }

  Widget _buildRow(Location l) {
    return ListTile(
      title: Text(
        l.name,
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LocationForm(
            location: l,
          ),
        ));
         refreshLocations();
      },
    );
  }
}
