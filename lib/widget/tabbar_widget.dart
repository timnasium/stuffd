import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarWidget extends StatelessWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> children;

  const TabBarWidget({
    Key? key,
    required this.title,
    required this.tabs,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: tabs.length,
      child: SafeArea(
          child: Scaffold(
        //backgroundColor: StuffdColors.bgColorScreen,

        appBar: AppBar(
          title: Text(title),
          shadowColor: NordColors.$0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.spicyRice(
              fontWeight: FontWeight.normal, fontSize: 50.0, color: NordColors.frost.lightest),
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 5,
            tabs: tabs,
            indicatorColor: NordColors.aurora.purple,
            labelStyle: GoogleFonts.secularOne( fontWeight: FontWeight.normal, fontSize: 16.0),
          ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: TabBarView(children: children),
              )),
            ]),
      )));
}
