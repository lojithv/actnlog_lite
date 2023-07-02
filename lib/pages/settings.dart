import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/activity_preset.dart';
import '../models/completed_activity.dart';
import '../store/activity_preset_store.dart';
import '../store/completed_activity_store.dart';
import '../store/current_activity_store.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String text = "Stop Service";

  final Uri _url = Uri.parse('https://www.buymeacoffee.com/lojithvdev');
  final Uri _privacyPolicy = Uri.parse(
      'https://www.privacypolicies.com/live/7c7e6372-8c32-4f63-a486-a471aec989e8');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final CurrentActivityStoreController currentActivityStoreController =
      Get.find<CurrentActivityStoreController>();

  final CompletedActivityStoreController completedActivityStoreController =
      Get.put(CompletedActivityStoreController());

  final ActivityPresetStoreController activityPresetStoreController =
      Get.put(ActivityPresetStoreController());

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchPrivacyPolicy() async {
    if (!await launchUrl(_privacyPolicy)) {
      throw Exception('Could not launch $_privacyPolicy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.titleSmall,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text(
                  "Clear All Presets",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Clear All Presets'),
                    content: const Text('This action cannot be undone.',
                        style: TextStyle(color: Colors.white70)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      TextButton(
                        onPressed: () => {
                          activityPresetStoreController
                              .activityPresetsList.value = <ActivityPreset>[],
                          _prefs.then((SharedPreferences prefs) {
                            prefs.remove('presets');
                          }),
                          Navigator.pop(context, 'OK')
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text(
                  "Clear Activity History",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Clear Activity History'),
                    content: const Text('This action cannot be undone.',
                        style: TextStyle(color: Colors.white70)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      TextButton(
                        onPressed: () => {
                          completedActivityStoreController.completedActivityList
                              .value = <CompletedActivity>[],
                          _prefs.then((SharedPreferences prefs) {
                            prefs.remove('completedActivities');
                          }),
                          Navigator.pop(context, 'OK')
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text(
                  "Clear Default Activity",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Clear Default Activity'),
                    content: const Text('This action cannot be undone.',
                        style: TextStyle(color: Colors.white70)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      TextButton(
                        onPressed: () => {
                          activityPresetStoreController.defaultActivity.value =
                              null,
                          _prefs.then((SharedPreferences prefs) {
                            prefs.remove('defaultActivityPreset');
                          }),
                          Navigator.pop(context, 'OK')
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text(
                  "Clear All Data",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Clear All Data'),
                    content: const Text('This action cannot be undone.',
                        style: TextStyle(color: Colors.white70)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      TextButton(
                        onPressed: () => {
                          activityPresetStoreController
                              .activityPresetsList.value = <ActivityPreset>[],
                          completedActivityStoreController.completedActivityList
                              .value = <CompletedActivity>[],
                          activityPresetStoreController.defaultActivity.value =
                              null,
                          _prefs.then((SharedPreferences prefs) {
                            prefs.remove('presets');
                            prefs.remove('completedActivities');
                            prefs.remove('defaultActivityPreset');
                          }),
                          Navigator.pop(context, 'OK')
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text(
                  "Privacy policy",
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => {
                _launchPrivacyPolicy()
              }
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                _launchUrl();
              },
              child: Card(
                  color: const Color.fromRGBO(43, 111, 243, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/bmc-full-logo.svg',
                      width: double.infinity,
                      height: 35,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
