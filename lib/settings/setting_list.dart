import 'dart:io';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'dart:convert';

import 'package:stuffd/helpers/loader.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  _SettingsList createState() => _SettingsList();
}

class _SettingsList extends State<SettingsList> {
  @override
  void initState() {
    super.initState();
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
                leading:  Icon(LineAwesomeIcons.file_export, size: 30),
                title: Row(children: [const Text('Export')]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Loader(),
                    ),
                  );
                },
              ),
           Divider(),
               ListTile(
                  leading:  Icon(LineAwesomeIcons.file_import, size: 30),
                title: Row(children: [const Text('Import')]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Loader(),
                    ),
                  );
                },
              ),
            ]),
          ],
        ));
  }
}
