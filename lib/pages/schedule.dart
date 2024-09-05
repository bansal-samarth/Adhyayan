import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:calendar_slider/calendar_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  const LivePage({super.key, required this.liveID, this.isHost = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1331073039,
        appSign:
            "185726600161acf517ded45b39ac51a38888ecbc018cc9bfd9e5059467313ff0",
        userID: 'user_id',
        userName: 'user_name',
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime _selectedDate;
  final Map<DateTime, List<UserInfo>> _sessions = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeSessions();
  }

  void _initializeSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final classId = prefs.getString('class') ?? '';
    final schoolName = prefs.getString('schoolName') ?? '';

    final apiUrl = Uri.parse(
        'https://mtqlvltkr5.execute-api.us-east-1.amazonaws.com/himesh?Class_ID=$classId&School_Name=$schoolName');

    final response = await http.get(apiUrl);

    final userInfoList = userInfoFromJson(response.body);

    for (var info in userInfoList) {
      final date = DateTime(info.date.year, info.date.month, info.date.day);
      if (_sessions.containsKey(date)) {
        _sessions[date]!.add(info);
      } else {
        _sessions[date] = [info];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          'Schedule',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/green_board.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Failed to load image')),
                  );
                },
              ),
              CalendarSlider(
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                selectedDateColor: Colors.white,
                selectedTileBackgroundColor: Colors.green,
                monthYearButtonBackgroundColor: Colors.black26,
                calendarEventColor: Colors.green,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: _buildSessionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    final sessionsForDay = _sessions[DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day)] ??
        [];
    if (sessionsForDay.isEmpty) {
      return Center(
        child: Text(
          'No sessions for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
          style: TextStyle(fontSize: 18, color: Colors.green[800]),
        ),
      );
    }
    return ListView.builder(
      itemCount: sessionsForDay.length,
      itemBuilder: (context, index) {
        final session = sessionsForDay[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: ListTile(
            title: Text(session.subject,
                style: TextStyle(
                    color: Colors.green[700], fontWeight: FontWeight.bold)),
            subtitle: Text(
                '${session.subjectContent}\n${session.time}\nDuration: ${session.duration}'),
            onTap: () {
              _showSessionDetails(session);
            },
          ),
        );
      },
    );
  }

  void _showSessionDetails(UserInfo session) {
    // Capture the current context
    BuildContext currentContext = context;

    showDialog(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(session.subject, style: TextStyle(color: Colors.green[800])),
          content: Text(
            '${session.subjectContent}\n${session.time}\nDuration: ${session.duration}',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Join Meeting',
                  style: TextStyle(color: Colors.green[800])),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final username = prefs.getString('schoolName');

                // Check if the widget is still mounted
                if (mounted) {
                  Navigator.of(currentContext)
                      .pop(); // Use the captured context
                  Navigator.push(
                    currentContext,
                    MaterialPageRoute(
                      builder: (context) =>
                          LivePage(liveID: username!, isHost: false),
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Host Meeting',
                  style: TextStyle(color: Colors.green[800])),
              onPressed: () {
                // Check if the widget is still mounted
                if (mounted) {
                  Navigator.of(currentContext)
                      .pop(); // Use the captured context
                  Navigator.push(
                    currentContext,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LivePage(liveID: 'your_live_id', isHost: true),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

List<UserInfo> userInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return List<UserInfo>.from(jsonData.map((item) => UserInfo.fromJson(item)));
}

String userInfoToJson(List<UserInfo> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

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
