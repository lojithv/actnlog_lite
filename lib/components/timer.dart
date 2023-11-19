import 'package:actnlog_lite/models/completed_activity.dart';
import 'package:actnlog_lite/models/current_activity.dart';
import 'package:actnlog_lite/store/current_activity_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../store/activity_preset_store.dart';
import '../store/completed_activity_store.dart';
import '../store/timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {

  final TimerController timerController = Get.put(TimerController());

  final CurrentActivityStoreController currentActivityStoreController =
      Get.find<CurrentActivityStoreController>();

  final CompletedActivityStoreController completedActivityStoreController =
      Get.put(CompletedActivityStoreController());

  final ActivityPresetStoreController activityPresetStoreController =
      Get.put(ActivityPresetStoreController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleStartTimer() async {
    var uuid = const Uuid();

    if (timerController.isRunning.value) {
      final SharedPreferences prefs =
          await _prefs;

      timerController
          .stopWatchTimerInstance
          .onResetTimer();
      timerController.isRunning
          .trigger(false);
      completedActivityStoreController
          .completedActivityList
          .add(CompletedActivity(
          id: currentActivityStoreController
              .currentActivity.value!
              .id,
          category: currentActivityStoreController
              .currentActivity.value!
              .category,
          name: currentActivityStoreController
              .currentActivity.value!
              .name,
          startTimeAndDate:
          currentActivityStoreController
              .currentActivity.value!
              .startTimeAndDate,
          endTimeAndDate:
          DateTime.now()
              .toIso8601String(),
          duration: timerController
              .stopWatchTimerInstance
              .rawTime
              .value));

      // Encode and store data in SharedPreferences
      String encodedData =
      CompletedActivity.encode(
          completedActivityStoreController
              .getCompletedActivityList()
              .cast());
      prefs.setString(
          "completedActivities",
          encodedData);
    } else {
      timerController
          .stopWatchTimerInstance
          .onStartTimer();
      timerController.isRunning
          .trigger(true);
      currentActivityStoreController
          .currentActivity.value =
          CurrentActivity(
              id: uuid.v1(),
              category: activityPresetStoreController
                  .defaultActivity
                  .value!
                  .category,
              name:
              activityPresetStoreController
                  .defaultActivity
                  .value!
                  .name,
              startTimeAndDate:
              DateTime.now()
                  .toIso8601String());

      // Create a new user with a first and last name
      final ongoingActivity = <String, dynamic>{
        "userid": "Ada",
        "start": "Lovelace",
        "activityid": 1815
      };

      db.collection("ongoing").add(ongoingActivity).then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => Visibility(
            visible:
                activityPresetStoreController.defaultActivity.value != null,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              color: const Color.fromRGBO(43, 111, 243, 1.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/timer');
                },
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder<int>(
                          stream:
                              timerController.stopWatchTimerInstance.rawTime,
                          initialData: timerController
                              .stopWatchTimerInstance.rawTime.value,
                          builder: (context, snap) {
                            final value = snap.data!;
                            final displayTime = StopWatchTimer.getDisplayTime(
                              value,
                              hours: timerController.isHours,
                              milliSecond: false,
                            );
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    displayTime,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                        activityPresetStoreController
                                            .defaultActivity.value!.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      )),
                                  Obx(() => ((activityPresetStoreController
                                              .defaultActivity.value!
                                              .category !=
                                          "")
                                      ? Text(
                                          activityPresetStoreController
                                              .defaultActivity.value!.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12,
                                          ),
                                        )
                                      : const SizedBox())),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        const Color.fromRGBO(21, 55, 122, 1.0),
                                    child: IconButton(
                                        iconSize: 30,
                                        onPressed: (){
                                          handleStartTimer();
                                        },
                                        icon: Obx(() => Icon(
                                              timerController.isRunning.isTrue
                                                  ? Icons.stop
                                                  : Icons.play_arrow,
                                              color: const Color.fromRGBO(
                                                  217, 217, 217, 1.0),
                                            ))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
