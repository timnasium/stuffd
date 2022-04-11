import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stuffd/category/category.dart';
import 'package:stuffd/helpers/loader.dart';
import 'package:stuffd/location/location.dart';

import 'package:stuffd/thing/thing.dart';
import 'package:stuffd/thing/upc_item.dart';
import 'package:stuffd/thing/upc_response.dart';
import 'package:stuffd/utils/database_manager.dart';

class ThingForm extends StatefulWidget {
  // In the constructor, require a Todo.
  ThingForm({Key? key, this.thing, this.thingResponse}) : super(key: key);

  final Thing? thing;
  final UpcResponse? thingResponse;

  @override
  State<ThingForm> createState() => _ThingFormState();
}

class _ThingFormState extends State<ThingForm> {
  bool isLoading = true;
  Thing? upcThing;
  List<Location>? locations;
  List<Category>? categories;

  final _formKey = GlobalKey<FormBuilderState>();

  var db = DatabaseManager.instance;

  @override
  void initState() {
    super.initState();
    preLoadData();
  }

  @override
  Widget build(BuildContext context) {
    String imgUrl = '';
    Thing newThing;

    Future deleteThing() async {
      await db.deleteThing(widget.thing!.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 4), content: Text('Saved!')));
      Navigator.of(context).pop();
    }

    List<Widget> thingActions() {
      if (widget.thing != null) {
        return <Widget>[
          IconButton(
            icon: Icon(LineAwesomeIcons.trash, size: 40),
            tooltip: "Delete",
            color: NordColors.aurora.red,
            onPressed: () {
              deleteThing();
            },
          ),
          const SizedBox(width: 20),
        ];
      } else
        return [];
    }

    if (isLoading) {
      return Loader();
    } else {
      if (widget.thing != null) {
        newThing = widget.thing!;
        imgUrl = widget.thing!.imageUrl;
      } else if (widget.thingResponse != null) {
        newThing = upcThing!;
        imgUrl = newThing.imageUrl;
      } else {
        newThing = new Thing(
            id: 0,
            name: '',
            normalName: '',
            description: '',
            brand: '',
            ean: '',
            upc: '',
            imageUrl: '',
            dateAdded: DateTime.now().millisecondsSinceEpoch,
            categoryId: 0,
            locationId: 0);
      }
      var title = 'New Item';
      if (widget.thing != null) {
        title = widget.thing!.name;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(title, textScaleFactor: 2.4,),
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.chevron_circle_left, size: 40),
            tooltip: "Back",
            color: NordColors.frost.lightest,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: thingActions(),
          centerTitle: true,
          toolbarHeight: 125,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //name
                FormBuilderTextField(
                  name: 'nameField',
                  validator: FormBuilderValidators.required(context),
                  valueTransformer: (value) {
                    return value?.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),

                FormBuilderTextField(
                  name: 'descriptionField',
                  minLines: 4,
                  maxLines: 6,
                  valueTransformer: (value) {
                    return value?.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),

                FormBuilderTextField(
                  name: 'brandField',
                  valueTransformer: (value) {
                    return value?.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'Brand',
                  ),
                ),

                FormBuilderTextField(
                  name: 'eanField',
                  valueTransformer: (value) {
                    return value?.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'EAN',
                  ),
                ),

                FormBuilderTextField(
                  name: 'upcField',
                  valueTransformer: (value) {
                    return value?.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'UPC',
                  ),
                ),

                FormBuilderDropdown(
                    name: 'locationField',
                    decoration: InputDecoration(
                      labelText: 'Location',
                    ),
                    items: locations!
                        .map((location) => DropdownMenuItem(
                              value: location.id.toString(),
                              child: Text(location.name),
                            ))
                        .toList()),
                FormBuilderDropdown(
                    name: 'categoryField',
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                    items: categories!
                        .map((category) => DropdownMenuItem(
                              value: category.id.toString(),
                              child: Text(category.name),
                            ))
                        .toList()),

                SizedBox(height: 20),
                Container(
                  child: ClipRRect(
                    child: Image.network(imgUrl),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 3,
                  ),
                ),

                const SizedBox(height: 20),
                Expanded(child: Container()),

                ListTile(
                    contentPadding: EdgeInsets.all(50),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                style:ElevatedButton.styleFrom(primary: NordColors.$2),
                                  //Reset Button
                                  onPressed: () {
                                    _formKey.currentState?.reset();
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: const Text('Reset', textScaleFactor: 2.5))),
                          const SizedBox(width: 50),
                          Expanded(
                              child: ElevatedButton(
                                style:ElevatedButton.styleFrom(primary: NordColors.$2),
                                  //Submit Button
                                  onPressed: () async {
                                    final validated =
                                        _formKey.currentState?.validate();

                                    if (validated ?? false) {
                                      _formKey.currentState?.save();
                                      final allVals =
                                          _formKey.currentState?.value;

                                      var saveThing = new Thing(
                                          id: newThing.id,
                                          name: _formKey
                                              .currentState?.value['nameField'],
                                          normalName: Item.normalizeName(_formKey
                                              .currentState
                                              ?.value['nameField']),
                                          description: _formKey.currentState
                                              ?.value['descriptionField'],
                                          brand: _formKey.currentState
                                              ?.value['brandField'],
                                          ean: _formKey
                                              .currentState?.value['eanField'],
                                          upc: _formKey
                                              .currentState?.value['upcField'],
                                          locationId: int.parse(_formKey
                                              .currentState
                                              ?.value['locationField']),
                                          categoryId: int.parse(_formKey.currentState?.value['categoryField']),
                                          dateAdded: DateTime.now().millisecondsSinceEpoch,
                                          imageUrl: imgUrl);
                                      if (newThing.id <= 0) {
                                        await db.addThing(saveThing);
                                      } else {
                                        await db.updateThing(saveThing);
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 4),
                                              content: Text('Saved!')));
                                      Navigator.of(context).pop(true);
                                    }
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: const Text('Submit', textScaleFactor: 2.5))),
                        ])),
              ],
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: {
              'nameField': newThing.name,
              'descriptionField': newThing.description,
              'brandField': newThing.brand,
              'eanField': newThing.ean,
              'upcField': newThing.upc,
              'locationField': newThing.locationId.toString(),
              'categoryField': newThing.categoryId.toString(),
            },
          ),
        ),
      );
    }
  }

  Future<void> preLoadData() async {
    setState(() => isLoading = true);
    await setUpcThing();
    await getDropDowns();

    setState(() => isLoading = false);
  }

  Future<void> getDropDowns() async {
    locations = await db.getLocations();
    locations!.add(Location(id: 0, description: '', name: ''));

    categories = await db.getCategories();
    categories!.add(Category(id: 0, name: '', matches: ''));
  }

  Future<void> setUpcThing() async {
    if (widget.thingResponse != null) {
      upcThing = await widget.thingResponse!.items![0].toThing();
    }
  }
}
