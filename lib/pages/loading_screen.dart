import 'dart:convert';

import 'package:actnlog_lite/models/activity_preset.dart';
import 'package:actnlog_lite/models/completed_activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../store/activity_preset_store.dart';
import '../store/completed_activity_store.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  var presets = [];
  var completedActivities = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final ActivityPresetStoreController activityPresetStoreController =
  Get.put(ActivityPresetStoreController());

  final CompletedActivityStoreController completedActivityStoreController =
  Get.put(CompletedActivityStoreController());

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
