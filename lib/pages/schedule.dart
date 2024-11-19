import 'package:adhyayan/models/session.dart';
import 'package:adhyayan/pages/host_meeting_page.dart';
import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  const LivePage({super.key, required this.liveID, this.isHost = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1976727116, // Fill in your appID from ZEGOCLOUD
        appSign: "ec8c1d4fb0465a38134da822c9a4cf5af131dabb5556835e00ec8078c873139d", // Fill in your appSign from ZEGOCLOUD
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
  final Map<DateTime, List<Session>> _sessions = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeSessions();
  }

  void _initializeSessions() {
    const jsonString = '''
    {
    "RequestItems": {
        "YourTableName": [
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "Mathematics"},
                        "Subject_Content": {"S": "Introduction to Algebra"},
                        "Date": {"S": "2024-11-21"},
                        "Time": {"S": "09:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "Science"},
                        "Subject_Content": {"S": "Photosynthesis Process"},
                        "Date": {"S": "2024-11-21"},
                        "Time": {"S": "09:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "History"},
                        "Subject_Content": {"S": "Ancient Civilizations"},
                        "Date": {"S": "2024-11-21"},
                        "Time": {"S": "10:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "English"},
                        "Subject_Content": {"S": "Basic Grammar"},
                        "Date": {"S": "2024-11-21"},
                        "Time": {"S": "10:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "History"},
                        "Subject_Content": {"S": "World War II Overview"},
                        "Date": {"S": "2024-11-20"},
                        "Time": {"S": "09:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "Mathematics"},
                        "Subject_Content": {"S": "Trigonometry: Sine and Cosine"},
                        "Date": {"S": "2024-11-20"},
                        "Time": {"S": "09:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "Geography"},
                        "Subject_Content": {"S": "Climate Change Effects"},
                        "Date": {"S": "2024-11-20"},
                        "Time": {"S": "10:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "Science"},
                        "Subject_Content": {"S": "Electricity and Magnetism"},
                        "Date": {"S": "2024-11-20"},
                        "Time": {"S": "10:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "Chemistry"},
                        "Subject_Content": {"S": "Organic Chemistry Basics"},
                        "Date": {"S": "2024-11-22"},
                        "Time": {"S": "09:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "Mathematics"},
                        "Subject_Content": {"S": "Calculus: Derivatives"},
                        "Date": {"S": "2024-11-22"},
                        "Time": {"S": "09:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "Physics"},
                        "Subject_Content": {"S": "Physics: Laws of Motion"},
                        "Date": {"S": "2024-11-22"},
                        "Time": {"S": "10:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "English"},
                        "Subject_Content": {"S": "Literature: Modern Poetry"},
                        "Date": {"S": "2024-11-22"},
                        "Time": {"S": "10:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "Mathematics"},
                        "Subject_Content": {"S": "Advanced Algebra"},
                        "Date": {"S": "2024-11-23"},
                        "Time": {"S": "09:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "Science"},
                        "Subject_Content": {"S": "Introduction to Physics"},
                        "Date": {"S": "2024-11-23"},
                        "Time": {"S": "09:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "History"},
                        "Subject_Content": {"S": "Middle Ages"},
                        "Date": {"S": "2024-11-23"},
                        "Time": {"S": "10:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "8"},
                        "Channel_ID": {"S": "1"},
                        "Subject": {"S": "English"},
                        "Subject_Content": {"S": "Reading Comprehension"},
                        "Date": {"S": "2024-11-23"},
                        "Time": {"S": "10:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "History"},
                        "Subject_Content": {"S": "Cold War Era"},
                        "Date": {"S": "2024-11-19"},
                        "Time": {"S": "09:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "Mathematics"},
                        "Subject_Content": {"S": "Advanced Trigonometry"},
                        "Date": {"S": "2024-11-19"},
                        "Time": {"S": "09:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "Geography"},
                        "Subject_Content": {"S": "Oceans and Currents"},
                        "Date": {"S": "2024-11-19"},
                        "Time": {"S": "10:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "9"},
                        "Channel_ID": {"S": "2"},
                        "Subject": {"S": "Science"},
                        "Subject_Content": {"S": "Electromagnetism"},
                        "Date": {"S": "2024-11-19"},
                        "Time": {"S": "10:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "Chemistry"},
                        "Subject_Content": {"S": "Chemical Bonding"},
                        "Date": {"S": "2024-11-24"},
                        "Time": {"S": "09:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "Mathematics"},
                        "Subject_Content": {"S": "Integral Calculus"},
                        "Date": {"S": "2024-11-24"},
                        "Time": {"S": "09:30 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "Physics"},
                        "Subject_Content": {"S": "Thermodynamics"},
                        "Date": {"S": "2024-11-25"},
                        "Time": {"S": "10:00 AM"}
                    }
                }
            },
            {
                "PutRequest": {
                    "Item": {
                        "Class_ID": {"S": "10"},
                        "Channel_ID": {"S": "3"},
                        "Subject": {"S": "English"},
                        "Subject_Content": {"S": "Shakespeare's Hamlet"},
                        "Date": {"S": "2024-11-25"},
                        "Time": {"S": "10:30 AM"}
                    }
                }
            }
        ]
    }
}''';

    final session = sessionFromJson(jsonString);

    for (var tableName in session.requestItems.yourTableName) {
      final item = tableName.putRequest.item;
      final date = DateTime.parse(item.date.s);
      final sessionForDay = Session(
        classId: item.classId.s,
        channelId: item.channelId.s,
        subject: item.subject.s,
        subjectContent: item.subjectContent.s,
        date: date,
        time: item.time.s,
      );

      if (_sessions.containsKey(date)) {
        _sessions[date]!.add(sessionForDay);
      } else {
        _sessions[date] = [sessionForDay];
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
  void _hostCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LivePage(liveID: 'your_live_id', isHost: true),
      ),
    );
  }

  void _joinCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LivePage(liveID: 'your_live_id', isHost: false),
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
          TextButton(
            child: Text('Join Meeting', style: TextStyle(color: Colors.green[800])),
            onPressed: () {
              Navigator.of(context).pop();

              // Navigate to LivePage for joining the meeting
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LivePage(liveID: session.channelId, isHost: false)),
              );
            },
          ),
          TextButton(
            child: Text('Host Meeting', style: TextStyle(color: Colors.green[800])),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to HostMeetingPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HostMeetingPage(liveID: session.channelId)),
              );
            },
          ),
        ],
      );
    },
  );
}
}
class Session {
  final String classId;
  final String channelId;
  final String subject;
  final String subjectContent;
  final DateTime date;
  final String time;

  Session({
    required this.classId,
    required this.channelId,
    required this.subject,
    required this.subjectContent,
    required this.date,
    required this.time,
  });
}