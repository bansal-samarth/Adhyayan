// To parse this JSON data, do
//
//     final session = sessionFromJson(jsonString);

import 'dart:convert';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  RequestItems requestItems;

  Session({
    required this.requestItems,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        requestItems: RequestItems.fromJson(json["RequestItems"]),
      );

  Map<String, dynamic> toJson() => {
        "RequestItems": requestItems.toJson(),
      };
}

class RequestItems {
  List<YourTableName> yourTableName;

  RequestItems({
    required this.yourTableName,
  });

  factory RequestItems.fromJson(Map<String, dynamic> json) => RequestItems(
        yourTableName: List<YourTableName>.from(
            json["YourTableName"].map((x) => YourTableName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "YourTableName":
            List<dynamic>.from(yourTableName.map((x) => x.toJson())),
      };
}

class YourTableName {
  PutRequest putRequest;

  YourTableName({
    required this.putRequest,
  });

  factory YourTableName.fromJson(Map<String, dynamic> json) => YourTableName(
        putRequest: PutRequest.fromJson(json["PutRequest"]),
      );

  Map<String, dynamic> toJson() => {
        "PutRequest": putRequest.toJson(),
      };
}

class PutRequest {
  Item item;

  PutRequest({
    required this.item,
  });

  factory PutRequest.fromJson(Map<String, dynamic> json) => PutRequest(
        item: Item.fromJson(json["Item"]),
      );

  Map<String, dynamic> toJson() => {
        "Item": item.toJson(),
      };
}

class Item {
  ChannelId classId;
  ChannelId channelId;
  ChannelId subject;
  ChannelId subjectContent;
  ChannelId date;
  ChannelId time;

  Item({
    required this.classId,
    required this.channelId,
    required this.subject,
    required this.subjectContent,
    required this.date,
    required this.time,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        classId: ChannelId.fromJson(json["Class_ID"]),
        channelId: ChannelId.fromJson(json["Channel_ID"]),
        subject: ChannelId.fromJson(json["Subject"]),
        subjectContent: ChannelId.fromJson(json["Subject_Content"]),
        date: ChannelId.fromJson(json["Date"]),
        time: ChannelId.fromJson(json["Time"]),
      );

  Map<String, dynamic> toJson() => {
        "Class_ID": classId.toJson(),
        "Channel_ID": channelId.toJson(),
        "Subject": subject.toJson(),
        "Subject_Content": subjectContent.toJson(),
        "Date": date.toJson(),
        "Time": time.toJson(),
      };
}

class ChannelId {
  String s;

  ChannelId({
    required this.s,
  });

  factory ChannelId.fromJson(Map<String, dynamic> json) => ChannelId(
        s: json["S"],
      );

  Map<String, dynamic> toJson() => {
        "S": s,
      };
}
