import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerController extends GetxController {
  bool isHours = true;
  var isRunning = false.obs;

  StopWatchTimer stopWatchTimerInstance = StopWatchTimer(
    mode: StopWatchMode.countUp,
  ); // Create instance.
}
