// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';

List<Announcement> announcementFromJson(String str) => List<Announcement>.from(
    json.decode(str).map((x) => Announcement.fromJson(x)));

String announcementToJson(List<Announcement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Announcement {
  DateTime key1Date;
  String content;
  String key2Time;
  String teacher;
  String subject;

  Announcement({
    required this.key1Date,
    required this.content,
    required this.key2Time,
    required this.teacher,
    required this.subject,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        key1Date: DateTime.parse(json["key1date"]),
        content: json["Content"],
        key2Time: json["key2time"],
        teacher: json["Teacher"],
        subject: json["Subject"],
      );

  Map<String, dynamic> toJson() => {
        "key1date":
            "${key1Date.year.toString().padLeft(4, '0')}-${key1Date.month.toString().padLeft(2, '0')}-${key1Date.day.toString().padLeft(2, '0')}",
        "Content": content,
        "key2time": key2Time,
        "Teacher": teacher,
        "Subject": subject,
      };
}
