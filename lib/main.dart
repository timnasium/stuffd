import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:stuffd/helpers/loader.dart';
import 'package:stuffd/thing/thing_list.dart';
import 'package:stuffd/utils/database_manager.dart';
import 'package:stuffd/widget/tabbar_widget.dart';

import 'category/category_list.dart';
import 'location/location_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await DatabaseManager.instance.database;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'StuFFd';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      themeMode: ThemeMode.dark,
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark().copyWith(
        textTheme: GoogleFonts.coustardTextTheme().apply(
          bodyColor: NordColors.snowStorm.darkest,
          displayColor: NordColors.snowStorm.darkest,
          
        ),
      ),

      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => 
       TabBarWidget(
        title: MyApp.title,
        tabs: [
          Tab(icon: Icon(LineAwesomeIcons.box,size:35, color: NordColors.aurora.orange), text: 'My Stuff'),
          Tab(icon: Icon(LineAwesomeIcons.map_marked,size:35, color: NordColors.aurora.green), text: 'Locations'),
          Tab(icon: Icon(LineAwesomeIcons.tags,size:35, color: NordColors.aurora.red), text: 'Categories'),
          Tab(icon: Icon(LineAwesomeIcons.cog,size:35, color: NordColors.aurora.yellow), text: 'Settings'),
        ],
        children: [
          ThingList(),
          LocationList(),
          CategoryList(),
         Loader(),
        ],
      );
}
