import 'package:actnlog_lite/models/activity_preset.dart';
import 'package:actnlog_lite/store/activity_preset_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddNewPreset extends StatefulWidget {
  const AddNewPreset({super.key});

  @override
  State<AddNewPreset> createState() => _AddNewPresetState();
}

class _AddNewPresetState extends State<AddNewPreset> {
  final activityInputController = TextEditingController();
  final categoryInputController = TextEditingController();

  final ActivityPresetStoreController activityPresetStoreController =
      Get.put(ActivityPresetStoreController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _validate = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    activityInputController.dispose();
    categoryInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(39, 39, 39, 1.0),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        height: 300,
        // color: Color.fromRGBO(39, 39, 39, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(
                'Activity',
                style: TextStyle(color: Colors.white),
              ),
              TextField(

                controller: activityInputController,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              const Text(
                'Category',
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                controller: categoryInputController,
                decoration: const InputDecoration(
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              InkWell(
                  onTap: () async {
                    final SharedPreferences prefs = await _prefs;
                    if (activityInputController.text != "") {
                      activityPresetStoreController.activityPresetsList.add(
                          ActivityPreset(
                              id: uuid.v1(),
                              category: categoryInputController.text,
                              name: activityInputController.text));

                      // Encode and store data in SharedPreferences
                      String encodedData = ActivityPreset.encode(
                          activityPresetStoreController
                              .getActivityPresetList()
                              .cast());
                      prefs.setString("presets", encodedData);
                      if (context.mounted) Navigator.pop(context);
                    } else {
                      setState(() {
                        activityInputController.text.isEmpty ? _validate = true : _validate = false;
                      });
                    }
                  },
                  child: const Card(
                      color: Color.fromRGBO(43, 111, 243, 1.0),
                      child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                              child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ))))),
            ],
          ),
        ),
      ),
    );
  }
}
