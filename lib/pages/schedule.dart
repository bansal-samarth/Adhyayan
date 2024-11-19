import 'dart:convert';
import 'package:adhyayan/pages/host_meeting_page.dart';
import 'package:adhyayan/pages/viewer_meeting_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:calendar_slider/calendar_slider.dart';




class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.fullName}) ;
  final String? fullName;

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime _selectedDate;
  List<Session> _sessions = [];
  bool _isLoading = false; // Loading state

  final Map<String, String> subjectContentMap = {
    'Maths': 'Algebra',
    'Science': 'Energy',
    'English': 'Life of Pie',
    'Hindi': 'Jeevan Dhara',
    'History': 'World History',
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchSessionsFromDynamoDB();
  }

  Future<void> _fetchSessionsFromDynamoDB() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    String dayOfWeek = DateFormat('EEEE').format(_selectedDate);

    const apiUrl =
        "https://mtqlvltkr5.execute-api.us-east-1.amazonaws.com/timetflambda";
    final queryParams = {
      "ClassDay": dayOfWeek,
      "Class_ID": "KV_8"
    };
    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List timetable = responseData['Timetable'];

        setState(() {
          _sessions = timetable.map((sessionData) {
            return Session(
              subject: sessionData['Subject'],
              subjectContent: subjectContentMap[sessionData['Subject']] ??
                  "General Topic",
              time: sessionData['ClassTime'],
            );
          }).toList();
        });
      } else {
        print("Failed to fetch sessions. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching sessions: $e");
    } finally {
      setState(() {
        _isLoading = false; // End loading
      });
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
              // Background image
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
              // Calendar slider
              CalendarSlider(
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now().add(const Duration(days: 7)),
                selectedDateColor: Colors.white,
                selectedTileBackgroundColor: Colors.green,
                monthYearButtonBackgroundColor: Colors.black26,
                calendarEventColor: Colors.green,
                onDateSelected: (date) {
                  setState(() {
                    _sessions.clear();
                    _selectedDate = date;
                    _fetchSessionsFromDynamoDB(); // Fetch data for the new date
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  )
                : _buildSessionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList() {
    if (_sessions.isEmpty) {
      return Center(
        child: Text(
          'No sessions for ${DateFormat('MMMM d, yyyy').format(_selectedDate)}',
          style: TextStyle(fontSize: 18, color: Colors.green[800]),
        ),
      );
    }

    return ListView.builder(
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: ListTile(
            title: Text(
              session.subject,
              style: TextStyle(
                  color: Colors.green[700], fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${session.subjectContent}\n${session.time}'),
            onTap: () {
              _showSessionDetails(session);
            },
          ),
        );
      },
    );
  }

  void _showSessionDetails(Session session) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(session.subject, style: TextStyle(color: Colors.green[800])),
        content: Text('${session.subjectContent}\n${session.time}'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              // Navigate to LivePage for joining the meeting
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const  LivePage(liveID: "123456", )),
              );
            },
            child: const Text('Join Meeting'),
          ),
          const SizedBox(width: 10), 
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to HostMeetingPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HostMeetingPage(liveID: "123456")),
              );
            },
            child: const Text('Host Meeting'),
          ),
        ],
      );
    },
  );
}

}

class Session {
  final String subject;
  final String subjectContent;
  final String time;

  Session({
    required this.subject,
    required this.subjectContent,
    required this.time,
  });
}
