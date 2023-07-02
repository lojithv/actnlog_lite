import 'dart:convert';

class CompletedActivity {
  final String id;
  final String name, category;
  final String startTimeAndDate;
  final String endTimeAndDate;
  final int duration;

  CompletedActivity(
      {required this.id,
      required this.category,
      required this.name,
      required this.startTimeAndDate,
      required this.endTimeAndDate,
      required this.duration});

  factory CompletedActivity.fromJson(Map<String, dynamic> jsonData) {
    return CompletedActivity(
        id: jsonData['id'],
        category: jsonData['category'],
        name: jsonData['name'],
        startTimeAndDate: jsonData['startTimeAndDate'],
        endTimeAndDate: jsonData['endTimeAndDate'],
        duration: jsonData['duration']);
  }

  static Map<String, dynamic> toMap(CompletedActivity activity) => {
        'id': activity.id,
        'category': activity.category,
        'name': activity.name,
        'startTimeAndDate': activity.startTimeAndDate,
        'endTimeAndDate': activity.endTimeAndDate,
        'duration': activity.duration
      };

  static String encode(List<CompletedActivity> activity) => json.encode(
        activity
            .map<Map<String, dynamic>>(
                (activityPreset) => CompletedActivity.toMap(activityPreset))
            .toList(),
      );

  static List<CompletedActivity> decode(String activity) =>
      (json.decode(activity) as List<dynamic>)
          .map<CompletedActivity>((item) => CompletedActivity.fromJson(item))
          .toList();
}
