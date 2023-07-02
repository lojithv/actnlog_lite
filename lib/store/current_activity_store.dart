import 'package:actnlog_lite/models/current_activity.dart';
import 'package:get/get.dart';

class CurrentActivityStoreController extends GetxController {
  Rx<CurrentActivity?> currentActivity = Rx<CurrentActivity?>(null);

  void setCurrentActivity(CurrentActivity activity) {
    currentActivity = activity.obs;
    update();
  }
}
