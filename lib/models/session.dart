// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

List<UserInfo> userInfoFromJson(String str) =>
    List<UserInfo>.from(json.decode(str).map((x) => UserInfo.fromJson(x)));

String userInfoToJson(List<UserInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfo {
  DateTime date;
  String subjectContent;
  String time;
  String duration;
  String subject;

  UserInfo({
    required this.date,
    required this.subjectContent,
    required this.time,
    required this.duration,
    required this.subject,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        date: DateTime.parse(json["Date"]),
        subjectContent: json["Subject_Content"],
        time: json["Time"],
        duration: json["Duration"],
        subject: json["Subject"],
      );

  Map<String, dynamic> toJson() => {
        "Date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "Subject_Content": subjectContent,
        "Time": time,
        "Duration": duration,
        "Subject": subject,
      };
}
