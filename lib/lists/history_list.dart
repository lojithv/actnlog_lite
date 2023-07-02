import 'package:actnlog_lite/store/completed_activity_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:lottie/lottie.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  var list = [];

  final CompletedActivityStoreController completedActivityStoreController =
      Get.put(CompletedActivityStoreController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => completedActivityStoreController
            .completedActivityList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GroupedListView<dynamic, String>(
              elements: completedActivityStoreController.completedActivityList,
              groupBy: (element) =>
                  element.startTimeAndDate.toString().split('T')[0],
              groupComparator: (value1, value2) =>
                  value2.split('T')[0].compareTo(value1.split('T')[0]),
              scrollDirection: Axis.vertical,
              order: GroupedListOrder.ASC,
              useStickyGroupSeparators: true, // optional
              floatingHeader: true,
              groupSeparatorBuilder: (String value) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: const Color.fromRGBO(43, 111, 243, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value.split('T')[0],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
              itemBuilder: (c, element) {
                return Card(
                  color: Colors.white10,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      element.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    element.category != ""
                                        ? Text(
                                            element.category,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              // Text(
                              //   completedActivityStoreController
                              //       .completedActivityList[index].startTimeAndDate
                              //       .toString()
                              //       .split('T')[0],
                              //   style: const TextStyle(
                              //       color: Colors.white, fontSize: 14),
                              // ),
                              Text(
                                StopWatchTimer.getDisplayTime(element.duration,
                                    milliSecond: false),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          ),
                        )),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/empty-history.json'),
              const Text(
                "No Activities found!",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          )));
  }
}
