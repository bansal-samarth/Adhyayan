// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

List<UserInfo> userInfoFromJson(String str) =>
    List<UserInfo>.from(json.decode(str).map((x) => UserInfo.fromJson(x)));

String userInfoToJson(List<UserInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfo {
  String schoolName;
  String gender;
  String fullName;
  String classId;
  String username;

  UserInfo({
    required this.schoolName,
    required this.gender,
    required this.fullName,
    required this.classId,
    required this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        schoolName: json["SchoolName"],
        gender: json["Gender"],
        fullName: json["Full Name"],
        classId: json["Class_ID"],
        username: json["Username"],
      );

  Map<String, dynamic> toJson() => {
        "SchoolName": schoolName,
        "Gender": gender,
        "Full Name": fullName,
        "Class_ID": classId,
        "Username": username,
      };
}
