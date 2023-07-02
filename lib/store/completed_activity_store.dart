import 'package:actnlog_lite/models/completed_activity.dart';
import 'package:get/get.dart';

class CompletedActivityStoreController extends GetxController {
  RxList completedActivityList = <CompletedActivity>[].obs;

  List getCompletedActivityList() {
    return completedActivityList.toList();
  }
}
