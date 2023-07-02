import 'package:actnlog_lite/models/activity_preset.dart';
import 'package:actnlog_lite/store/activity_preset_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagePresetSheet extends StatefulWidget {
  const ManagePresetSheet(
      {super.key, required this.preset, required this.presetIndex});

  final ActivityPreset preset;
  final int presetIndex;

  @override
  State<ManagePresetSheet> createState() => _ManagePresetSheetState();
}

class _ManagePresetSheetState extends State<ManagePresetSheet> {
  final activityInputController = TextEditingController();
  final categoryInputController = TextEditingController();

  final ActivityPresetStoreController activityPresetStoreController =
      Get.put(ActivityPresetStoreController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    activityInputController.text = widget.preset.name;
    categoryInputController.text = widget.preset.category;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    activityInputController.dispose();
    categoryInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(39, 39, 39, 1.0),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        height: 360,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: InkWell(
                        onTap: () async {
                          final SharedPreferences prefs = await _prefs;
                          activityPresetStoreController
                                  .activityPresetsList[widget.presetIndex] =
                              ActivityPreset(
                                  id: widget.preset.id,
                                  category: categoryInputController.text,
                                  name: activityInputController.text);
                          // Encode and store data in SharedPreferences
                          String encodedData = ActivityPreset.encode(
                              activityPresetStoreController.getActivityPresetList()
                                  .cast());
                          prefs.setString("presets", encodedData);
                          if (context.mounted) Navigator.pop(context);
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
                  ),
                  Expanded(
                      child: Card(
                          color: const Color.fromRGBO(128, 38, 32, 1.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final SharedPreferences prefs = await _prefs;
                              activityPresetStoreController.activityPresetsList
                                  .removeAt(widget.presetIndex);
                              // Encode and store data in SharedPreferences
                              String encodedData = ActivityPreset.encode(
                                  activityPresetStoreController.getActivityPresetList()
                                      .cast());
                              prefs.setString("presets", encodedData);
                              if (context.mounted) Navigator.pop(context);
                            },
                          )))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
