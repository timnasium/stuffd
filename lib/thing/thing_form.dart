import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stuffd/category/category.dart';
import 'package:stuffd/helpers/fileHelper.dart';
import 'package:stuffd/helpers/loader.dart';
import 'package:stuffd/location/location.dart';

import 'package:stuffd/thing/thing.dart';
import 'package:stuffd/thing/upc_item.dart';
import 'package:stuffd/thing/upc_response.dart';
import 'package:stuffd/utils/database_manager.dart';
import 'package:stuffd/widget/stuffd_button.dart';

class ThingForm extends StatefulWidget {
  // In the constructor, require a Todo.
  ThingForm({Key? key, this.thing, this.thingResponse, this.scansLeft})
      : super(key: key);

  final Thing? thing;
  final UpcResponse? thingResponse;
  final int? scansLeft;

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
            icon: Icon(LineAwesomeIcons.trash, size: 30),
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
          title: Text(
            title,
            //textScaleFactor: 2.4,
          ),
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.chevron_circle_left, size: 30),
            tooltip: "Back",
            color: NordColors.frost.lightest,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: thingActions(),
          centerTitle: true,
          //toolbarHeight: 125,
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

                            //Reset Button
                            onPressed: () {
                              _formKey.currentState?.reset();
                              FocusScope.of(context).unfocus();
                            },
                            text: 'Reset')),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: StuffdButton(

                            //Submit Button
                            onPressed: () async {
                              final validated =
                                  _formKey.currentState?.validate();

                              if (validated ?? false) {
                                _formKey.currentState?.save();
                                final allVals = _formKey.currentState?.value;

                                var saveThing = new Thing(
                                    id: newThing.id,
                                    name: _formKey
                                        .currentState?.value['nameField'],
                                    normalName: Item.normalizeName(_formKey
                                        .currentState?.value['nameField']),
                                    description: _formKey.currentState
                                        ?.value['descriptionField'],
                                    brand: _formKey
                                        .currentState?.value['brandField'],
                                    ean: _formKey
                                        .currentState?.value['eanField'],
                                    upc: _formKey
                                        .currentState?.value['upcField'],
                                    locationId: int.parse(_formKey
                                        .currentState?.value['locationField']),
                                    categoryId: int.parse(_formKey
                                        .currentState?.value['categoryField']),
                                    dateAdded:
                                        DateTime.now().millisecondsSinceEpoch,
                                    imageUrl: imgUrl);
                                if (newThing.id <= 0) {
                                  await db.addThing(saveThing);
                                } else {
                                  await db.updateThing(saveThing);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration: const Duration(seconds: 4),
                                        content: Text('Saved!')));
                                Navigator.of(context).pop(true);
                              }
                              FocusScope.of(context).unfocus();
                            },
                            text: 'Submit')),
                  ])),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: upcThing == null
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 300,
                          color: NordColors.polarNight.darkest,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                             Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    IconButton(
                                          color: NordColors.aurora.purple,
                                          onPressed: () => Clipboard.setData(
                                              ClipboardData(
                                                  text: widget.thingResponse!
                                                      .items![0].category!)),
                                          icon: Icon(LineAwesomeIcons.copy)),
                                        SizedBox(
                                           width: MediaQuery.of(context).size.width * 0.65,
                                           
                                          child: Text('Category: ' +
                                                widget.thingResponse!.items![0]
                                                    .category!,
                                                    softWrap: true,
                                                   overflow: TextOverflow.ellipsis,
     maxLines: 2,),
                                        ),
                                       
                                    
                                     
                                    ],
                                  ),
                                  
                                SizedBox(
                                  height: 25,
                                ),
                                Text('Scans Left: ' +
                                    widget.scansLeft!.toString()),
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: StuffdButton(
                                    text: 'Close',
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                backgroundColor: NordColors.aurora.purple,
                child: const Icon(
                  LineAwesomeIcons.code,
                  color: NordColors.$0,
                  size: 40,
                ),
              ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //name
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

                  imgUrl.isNotEmpty?
                  Container(
                    child: ClipRRect(
                      child: Image.network(imgUrl),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *.8,
                        maxHeight: 500,
                        minHeight: 150),
                  ):
                  Column(
                    children: [
                      Text('Load your own image'),
                      ElevatedButton(onPressed: (){
                        getFile();
                      }, child: Text("Select an Image")),
                    ],
                  ),//No Image
                  SizedBox(height: 160),
                ],
              ),
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
