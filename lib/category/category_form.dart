import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stuffd/category/category.dart';
import 'package:stuffd/utils/database_manager.dart';
import 'package:stuffd/widget/stuffd_button.dart';

class CategoryForm extends StatelessWidget {
  // In the constructor, require a Todo.
  CategoryForm({Key? key, this.category}) : super(key: key);

  final Category? category;

  final _formKey = GlobalKey<FormBuilderState>();
  var db = DatabaseManager.instance;

  @override
  Widget build(BuildContext context) {
    Category newCategory;

    if (category != null) {
      newCategory = category!;
    } else {
      newCategory = new Category(id: 0, name: '', matches: '');
    }
    var title = 'New Category';
    if (category != null) {
      title = category!.name;
    }

    Future delete() async {
      await db.deleteCategory(category!.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 4), content: Text('Saved!')));
      Navigator.of(context).pop();
    }

    List<Widget> categoryActions() {
      if (category != null) {
        return <Widget>[
          IconButton(
            icon: Icon(LineAwesomeIcons.trash, size: 30),
            tooltip: "Delete",
            color: NordColors.aurora.red,
            onPressed: () {
              delete();
            },
          ),
          const SizedBox(width: 20),
        ];
      } else
        return [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title
        ),
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.chevron_circle_left, size: 30),
          tooltip: "Back",
          color: NordColors.frost.lightest,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: categoryActions(),
        centerTitle: true,

      ),
      bottomSheet: SizedBox(
          height: 80,
          child: ListTile(
             contentPadding: EdgeInsets.fromLTRB(50,10,50,15),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: StuffdButton(
                            text: "Reset",
                            onPressed: () {
                              _formKey.currentState?.reset();
                              FocusScope.of(context).unfocus();
                            })),
                    const SizedBox(width: 50),
                    Expanded(
                        child: StuffdButton(
                      text: "Submit",
                      onPressed: () async {
                        final validated = _formKey.currentState?.validate();

                        if (validated ?? false) {
                          _formKey.currentState?.save();
                          final allVals = _formKey.currentState?.value;

                          var saveCategory = new Category(
                              id: newCategory.id,
                              name: _formKey.currentState?.value['nameField'],
                              matches:
                                  _formKey.currentState?.value['matchesField']);
                          if (newCategory.id <= 0) {
                            await db.addCategory(saveCategory);
                          } else {
                            await db.updateCategory(saveCategory);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 4),
                              content: Text('Saved!')));
                          Navigator.of(context).pop();
                        }
                        FocusScope.of(context).unfocus();
                      },
                    )),
                  ]))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              FormBuilderTextField(
                name: 'nameField',
                validator: FormBuilderValidators.required(),
                valueTransformer: (value) {
                  return value?.trim();
                },
                 decoration: InputDecoration(
                      labelText: 'Name',
                    ),
              ),
              FormBuilderTextField(name: 'matchesField',minLines: 5,maxLines: 15,
               decoration: InputDecoration(
                      labelText: 'Matches',
                       helperText: 'Category response matches, separated by a |',
                    ),),
              const SizedBox(height: 160),
              
              
            ]),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: {
            'nameField': newCategory.name,
            'matchesField': newCategory.matches,
          },
        ),
      ),
    );
  }
}
