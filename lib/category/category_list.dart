import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stuffd/category/category.dart';
import 'package:stuffd/category/category_form.dart';

import 'package:stuffd/utils/database_manager.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late List<Category> _categories;
  bool isLoading = false;
  var db = DatabaseManager.instance;
  @override
  void initState() {
    super.initState();
    refreshCategories();
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
            builder: (context) => CategoryForm(),
          ));
          refreshCategories();
        },
        backgroundColor: NordColors.aurora.purple,
        child: const Icon(
          LineAwesomeIcons.plus,
          color: NordColors.$0, size:40,
        ),
      ),
    );
  }

  Future refreshCategories() async {
    setState(() => isLoading = true);
    this._categories = await db.getCategories();
    setState(() => isLoading = false);
  }

  Widget _buildList() {
    if (!isLoading && _categories.isNotEmpty) {
      return ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: _categories.length * 2,
          itemBuilder: (BuildContext _context, int i) {
            if (i.isOdd) {
              return Divider();
            }

            int index = i ~/ 2;
            if (index < _categories.length)
              return _buildRow(_categories[index]);
            else
              return Divider();
          });
    } else {
      return Center(
        child: Text("What is what?"),
      );
    }
  }

  Widget _buildRow(Category l) {
    return ListTile(
      title: Text(
        l.name,
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryForm(
            category: l,
          ),
        ));
        refreshCategories();
      },
    );
  }
}
