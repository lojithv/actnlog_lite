import 'dart:convert';

class ActivityPreset {
  final String id;
  final String name, category;

  ActivityPreset(
      {required this.id, required this.category, required this.name});

  factory ActivityPreset.fromJson(Map<String, dynamic> jsonData) {
    return ActivityPreset(
      id: jsonData['id'],
      category: jsonData['category'],
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(ActivityPreset activityPreset) => {
        'id': activityPreset.id,
        'category': activityPreset.category,
        'name': activityPreset.name
      };

  static String encode(List<ActivityPreset> activityPresets) => json.encode(
        activityPresets
            .map<Map<String, dynamic>>(
                (activityPreset) => ActivityPreset.toMap(activityPreset))
            .toList(),
      );

  static List<ActivityPreset> decode(String activityPresets) =>
      (json.decode(activityPresets) as List<dynamic>)
          .map<ActivityPreset>((item) => ActivityPreset.fromJson(item))
          .toList();
}
