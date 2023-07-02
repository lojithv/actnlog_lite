import 'dart:convert';

class CurrentActivity {
  final String id;
  final String name, category;
  final String startTimeAndDate;

  CurrentActivity(
      {required this.id,
      required this.category,
      required this.name,
      required this.startTimeAndDate});

  factory CurrentActivity.fromJson(Map<String, dynamic> jsonData) {
    return CurrentActivity(
      id: jsonData['id'],
      category: jsonData['category'],
      name: jsonData['name'],
      startTimeAndDate: jsonData['startTimeAndDate'],
    );
  }

  static Map<String, dynamic> toMap(CurrentActivity activity) => {
        'id': activity.id,
        'category': activity.category,
        'name': activity.name,
        'startTimeAndDate': activity.startTimeAndDate
      };

  static String encode(List<CurrentActivity> activity) => json.encode(
        activity
            .map<Map<String, dynamic>>(
                (activityPreset) => CurrentActivity.toMap(activityPreset))
            .toList(),
      );

  static List<CurrentActivity> decode(String activity) =>
      (json.decode(activity) as List<dynamic>)
          .map<CurrentActivity>((item) => CurrentActivity.fromJson(item))
          .toList();
}
