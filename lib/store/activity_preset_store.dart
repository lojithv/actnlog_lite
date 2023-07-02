import 'package:actnlog_lite/models/activity_preset.dart';
import 'package:get/get.dart';

class ActivityPresetStoreController extends GetxController {
  RxList activityPresetsList = <ActivityPreset>[].obs;

  Rx<ActivityPreset?> defaultActivity = Rx<ActivityPreset?>(null);

  List getActivityPresetList(){
    return activityPresetsList.toList();
  }
}
