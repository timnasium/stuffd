import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:stuffd/helpers/loader.dart';
import 'package:stuffd/utils/database_manager.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  _SettingsList createState() => _SettingsList();
}

class _SettingsList extends State<SettingsList> {
  var db = DatabaseManager.instance;
  @override
  void initState() {
    super.initState();
  }

  generateCsv() async {
    var export = await db.getExport();
    var expMap = export.map((e) => e.csvRow).toList();
    expMap.insert(0, export[0].csvHeaderRow);

    String csvData = ListToCsvConverter().convert(expMap);
    final String directory = (await getTemporaryDirectory()).path;
    final path = p.join(directory, "csv-${DateTime.now().second}.csv");

    if (Platform.isWindows) {
      var savePath =
          await FilePicker.platform.saveFile(fileName: "stuffd-export.csv");
      final File file = File(savePath!);
      await file.writeAsString(csvData);
    } else {
      final File file = File(path);
      await file.writeAsString(csvData);
      Share.shareFiles([path], text: 'My Stuff!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ListView(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 100),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(LineAwesomeIcons.file_export, size: 30),
                title: Row(children: [const Text('Export')]),
                onTap: () {
                  generateCsv();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(LineAwesomeIcons.file_import, size: 30),
                title: Row(children: [const Text('Import (coming soon)')]),
                textColor: NordColors.$3,
                iconColor: NordColors.$3,
                onTap: () {
             
                },
              ),
            ]),
      ],
    ));
  }
}
