import 'package:actnlog_lite/store/timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

import '../models/completed_activity.dart';
import '../models/current_activity.dart';
import '../store/activity_preset_store.dart';
import '../store/completed_activity_store.dart';
import '../store/current_activity_store.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final TimerController timerController = Get.find();

  final CurrentActivityStoreController currentActivityStoreController =
      Get.put(CurrentActivityStoreController());

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
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();

    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Display stop watch time
              StreamBuilder<int>(
                stream: timerController.stopWatchTimerInstance.rawTime,
                initialData:
                    timerController.stopWatchTimerInstance.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(value,
                      hours: timerController.isHours, milliSecond: false);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              ),

              /// Button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(() => Text(
                        activityPresetStoreController
                                .defaultActivity.value?.name ??
                            '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      )),
                  Obx(() => Text(
                        activityPresetStoreController
                                .defaultActivity.value?.category ??
                            '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 12,
                        ),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          const Color.fromRGBO(41, 106, 232, 1.0),
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () async {
                          if (timerController.isRunning.value) {
                            final SharedPreferences prefs = await _prefs;

                            timerController.stopWatchTimerInstance
                                .onResetTimer();
                            timerController.isRunning.trigger(false);
                            completedActivityStoreController
                                .completedActivityList
                                .add(CompletedActivity(
                                    id: currentActivityStoreController
                                        .currentActivity.value!.id,
                                    category: currentActivityStoreController
                                        .currentActivity.value!.category,
                                    name: currentActivityStoreController
                                        .currentActivity.value!.name,
                                    startTimeAndDate:
                                        currentActivityStoreController
                                            .currentActivity.value!
                                            .startTimeAndDate,
                                    endTimeAndDate:
                                        DateTime.now().toIso8601String(),
                                    duration: timerController
                                        .stopWatchTimerInstance
                                        .rawTime
                                        .value));

                            // Encode and store data in SharedPreferences
                            String encodedData = CompletedActivity.encode(
                                completedActivityStoreController
                                    .getCompletedActivityList()
                                    .cast());
                            prefs.setString(
                                "completedActivities", encodedData);
                          } else {
                            timerController.stopWatchTimerInstance
                                .onStartTimer();
                            timerController.isRunning.trigger(true);
                            currentActivityStoreController.currentActivity.value =
                                CurrentActivity(
                                    id: uuid.v1(),
                                    category: activityPresetStoreController
                                        .defaultActivity.value!.category,
                                    name: activityPresetStoreController
                                        .defaultActivity.value!.name,
                                    startTimeAndDate:
                                        DateTime.now().toIso8601String());
                          }
                        },
                        icon: Obx(
                          () => Icon(
                              timerController.isRunning.value
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color:
                                  const Color.fromRGBO(217, 217, 217, 1.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
