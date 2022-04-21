import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stuffd/location/location.dart';
import 'package:stuffd/utils/database_manager.dart';
import 'package:stuffd/widget/stuffd_button.dart';

class LocationForm extends StatelessWidget {
  // In the constructor, require a Todo.
  LocationForm({Key? key, this.location}) : super(key: key);

  final Location? location;

  final _formKey = GlobalKey<FormBuilderState>();
  var db = DatabaseManager.instance;

  @override
  Widget build(BuildContext context) {
    Location newLocation;

    if (location != null) {
      newLocation = location!;
    } else {
      newLocation = new Location(id: 0, name: '', description: '');
    }
    var title = 'New Location';
    if (location != null) {
      title = location!.name;
    }

    Future delete() async {
      await db.deleteLocation(location!.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 4), content: Text('Saved!')));
      Navigator.of(context).pop();
    }

    List<Widget> locationActions() {
      if (location != null) {
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
          icon: Icon(
            LineAwesomeIcons.chevron_circle_left,
            size: 30,
          ),
          tooltip: "Back",
          color: NordColors.frost.lightest,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: locationActions(),
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
                        },
                      ),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: StuffdButton(
                        text: "Submit",
                        onPressed: () async {
                          final validated = _formKey.currentState?.validate();

                          if (validated ?? false) {
                            _formKey.currentState?.save();
                            final allVals = _formKey.currentState?.value;

                            var saveLocation = new Location(
                                id: newLocation.id,
                                name: _formKey.currentState?.value['nameField'],
                                description: _formKey
                                    .currentState?.value['descriptionField']);
                            if (newLocation.id <= 0) {
                              await db.addLocation(saveLocation);
                            } else {
                              await db.updateLocation(saveLocation);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 4),
                                content: Text('Saved!')));
                            Navigator.of(context).pop();
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ]))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
          
                  SizedBox(height: 160),
              ],
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: {
            'nameField': newLocation.name,
            'descriptionField': newLocation.description,
          },
        ),
      ),
    );
  }
}
