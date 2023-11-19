import 'dart:convert';

import 'package:actnlog_lite/main.dart';
import 'package:actnlog_lite/models/activity_preset.dart';
import 'package:actnlog_lite/models/completed_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/current_activity.dart';
import '../store/activity_preset_store.dart';
import '../store/completed_activity_store.dart';
import '../store/current_activity_store.dart';
import '../store/timer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  var presets = [];
  var completedActivities = [];

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isSignedIn = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TimerController timerController = Get.put(TimerController());

  final CurrentActivityStoreController currentActivityStoreController =
  Get.put(CurrentActivityStoreController());

  final ActivityPresetStoreController activityPresetStoreController =
  Get.put(ActivityPresetStoreController());

  final CompletedActivityStoreController completedActivityStoreController =
  Get.put(CompletedActivityStoreController());

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        setState(() {
          _isSignedIn = account != null;
        });
        String? userid =  _googleSignIn.currentUser?.id;
        if(userid != null){
          print(userid);
          loadDatafromDB(userid);
        }
        // Redirect based on sign-in status
        _redirectBasedOnSignInStatus();
      });

      // Check if already signed in
      _googleSignIn.signInSilently();
    });

    _prefs.then((SharedPreferences prefs) {
      var presetsString = prefs.getString('presets');
      if(presetsString != null){
        presets = ActivityPreset.decode(presetsString);
        activityPresetStoreController.activityPresetsList.value = presets;
      }

      var completedActivitiesString = prefs.getString('completedActivities');
      if(completedActivitiesString != null){
        completedActivities = CompletedActivity.decode(completedActivitiesString);
        completedActivityStoreController.completedActivityList.value = completedActivities;
      }

      var defaultActivityPresetString = prefs.getString('defaultActivityPreset');
      if(defaultActivityPresetString != null){
        ActivityPreset defaultActivityPreset;
        defaultActivityPreset = ActivityPreset.fromJson(json.decode(defaultActivityPresetString));
        activityPresetStoreController.defaultActivity.value = defaultActivityPreset;
      }
    });
  }

  Future<void> loadDatafromDB(String userid) async {
    // Reference to the collection
    CollectionReference<Map<String, dynamic>> ongoing = db.collection('ongoing');

    // Query for the user with the given user ID
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await ongoing.where('userid', isEqualTo: "Ada").get();

    // Check if the query returned any documents
    if (querySnapshot.docs.isNotEmpty) {
      // Return the first document (assuming userId is unique)

      print(querySnapshot.docs.first.data());

      // Get the current time
      // Parse the start time string to DateTime
      DateTime startTime = DateTime.parse(querySnapshot.docs.first.data()['start']);
      DateTime currentTime = DateTime.now();
      timerController
          .stopWatchTimerInstance
          .setPresetTime(mSec: currentTime.difference(startTime).inMilliseconds);
      timerController
          .stopWatchTimerInstance
          .onStartTimer();
      timerController.isRunning
          .trigger(true);
      currentActivityStoreController
          .currentActivity.value =
          CurrentActivity(
              id: "test",
              category: "test",
              name:
              "test",
              startTimeAndDate:
              querySnapshot.docs.first.data()['start']);
    } else {
      // Return null if no matching user is found
      null;
    }
  }

  void _redirectBasedOnSignInStatus() {
    if (_isSignedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      // Implement logic for cases when the user is not signed in
      // For example, you could show a login screen or another welcome screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(43, 111, 243, 1.0),
      body: Center(
        child: Lottie.asset('assets/loading_animation.json'),
      ),
    );
  }
}
