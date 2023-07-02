import 'dart:convert';

import 'package:actnlog_lite/components/manage_preset_sheet.dart';
import 'package:actnlog_lite/models/activity_preset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../store/activity_preset_store.dart';
import '../store/current_activity_store.dart';
import '../store/timer.dart';

class ActivityPresetsList extends StatefulWidget {
  const ActivityPresetsList({super.key});

  @override
  State<ActivityPresetsList> createState() => _ActivityPresetsListState();
}

class _ActivityPresetsListState extends State<ActivityPresetsList> {
  final ActivityPresetStoreController activityPresetStoreController =
      Get.put(ActivityPresetStoreController());

  final CurrentActivityStoreController currentActivityStoreController =
      Get.put(CurrentActivityStoreController());

  final TimerController timerController = Get.put(TimerController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: activityPresetStoreController.activityPresetsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount: activityPresetStoreController
                            .activityPresetsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return activityPresetStoreController
                                      .activityPresetsList[index].name !=
                                  ""
                              ? InkWell(
                                  onTap: () {
                                    if (!timerController.isRunning.value) {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return ManagePresetSheet(
                                              preset:
                                                  activityPresetStoreController
                                                          .activityPresetsList[
                                                      index],
                                              presetIndex: index);
                                        },
                                      );
                                    }
                                  },
                                  child: Card(
                                    color: Colors.white10,
                                    child: SizedBox(
                                        width: double.infinity,
                                        height: 55,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          activityPresetStoreController
                                                              .activityPresetsList[
                                                                  index]
                                                              .name,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        if (activityPresetStoreController
                                                                .activityPresetsList[
                                                                    index]
                                                                .category !=
                                                            "")
                                                          Text(
                                                            activityPresetStoreController
                                                                .activityPresetsList[
                                                                    index]
                                                                .category,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Obx(() => Radio<String>(
                                                    value:
                                                        activityPresetStoreController
                                                            .activityPresetsList[
                                                                index]
                                                            .id,
                                                    groupValue:
                                                        activityPresetStoreController
                                                            .defaultActivity
                                                            .value
                                                            ?.id,
                                                    activeColor: Colors.white,
                                                    onChanged:
                                                        (String? value) async {
                                                      if (timerController
                                                              .isRunning
                                                              .value !=
                                                          true) {
                                                        activityPresetStoreController
                                                                .defaultActivity
                                                                .value =
                                                            activityPresetStoreController
                                                                    .activityPresetsList[
                                                                index];
                                                        final SharedPreferences
                                                            prefs =
                                                            await _prefs;

                                                        // Encode and store data in SharedPreferences
                                                        String encodedData = json.encode(
                                                            ActivityPreset.toMap(
                                                                activityPresetStoreController
                                                                        .activityPresetsList[
                                                                    index]));
                                                        prefs.setString(
                                                            "defaultActivityPreset",
                                                            encodedData);
                                                      }
                                                    },
                                                  )),
                                            ],
                                          ),
                                        )),
                                  ),
                                )
                              : const SizedBox();
                        },
                      )),
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Lottie.asset('assets/sadface-animation.json'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "No Presets Yet",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tap the ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white70,
                        ),
                        Text(
                          " icon to get started",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                )),
        ));
  }
}
