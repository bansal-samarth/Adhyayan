import 'package:adhyayan/models/announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final List<Notice> _notices = [];

  int _visibleNoticesCount = 4;

  @override
  void initState() {
    super.initState();
    _fetchNotices();
  }

  DateTime parseNoticeDateTime(String date, String time) {
    // Convert the time to 24-hour format
    final timeParts = time.split(' ');
    final timeOfDay = timeParts[1].toLowerCase();
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    if (timeOfDay == 'pm' && hour != 12) {
      hour += 12;
    } else if (timeOfDay == 'am' && hour == 12) {
      hour = 0;
    }

    final formattedTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
    final dateTimeString = '$date $formattedTime';

    // Parse the date with the new formatted time
    return DateTime.parse(dateTimeString);
  }

  Future<void> _fetchNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final schoolName = prefs.getString('schoolName');
    final classID = prefs.getString('class');

    if (schoolName != null && classID != null) {
      await _getNoticesFromApi(schoolName, classID);
    }
  }

  Future<void> _getNoticesFromApi(String schoolName, String classID) async {
    final response = await http.get(Uri.parse(
        'https://mtqlvltkr5.execute-api.us-east-1.amazonaws.com/anoouncementlambda?Class_ID=$classID&School=$schoolName'));

    if (response.statusCode == 200) {
      final List<Announcement> announcements =
          announcementFromJson(response.body);

      if (mounted) {
        setState(() {
          _notices.clear();
          for (var announcement in announcements) {
            _notices.add(
              Notice(
                date: announcement.key1Date.toIso8601String().substring(0, 10),
                time: announcement.key2Time,
                name: announcement.teacher,
                subject: announcement.subject,
                content: announcement.content,
              ),
            );
          }
          // Sort notices by date and time (newest first)
          _notices.sort((a, b) {
            DateTime dateTimeA = parseNoticeDateTime(a.date, a.time);
            DateTime dateTimeB = parseNoticeDateTime(b.date, b.time);
            return dateTimeB.compareTo(dateTimeA);
          });
        });
      }
    } else {
      if (mounted) {
        // Handle error gracefully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load notices')),
        );
      }
    }
  }

  void _showMoreNotices() {
    setState(() {
      _visibleNoticesCount =
          (_visibleNoticesCount + 2).clamp(0, _notices.length);
    });
  }

  String calculateDaysAgo(String noticeDate) {
    DateTime noticeDateTime = DateTime.parse(noticeDate);
    DateTime currentDate = DateTime.now();

    Duration difference = currentDate.difference(noticeDateTime);
    int daysAgo = difference.inDays;

    // Check if the notice is from today
    if (daysAgo == 0) {
      int hoursAgo = difference.inHours;
      return hoursAgo > 0 ? '$hoursAgo hours ago' : 'Just now';
    }

    // Check if the notice is from yesterday
    if (currentDate.day - noticeDateTime.day == 1 &&
        currentDate.month == noticeDateTime.month &&
        currentDate.year == noticeDateTime.year) {
      return 'Yesterday';
    }

    // For other cases, return days ago
    return '$daysAgo days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.activity,
          style:
              const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _notices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Notice Board',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.green[600],
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            width: 80,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._notices.take(_visibleNoticesCount).map((notice) {
                    return NoticeButton(
                      date: notice.date,
                      time: notice.time,
                      name: notice.name,
                      subject: notice.subject,
                      content: notice.content,
                      daysAgo: calculateDaysAgo(notice.date),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeDetailPage(
                              subject: notice.subject,
                              content: notice.content,
                              name: notice.name,
                              date: notice.date,
                              time: notice.time,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  if (_visibleNoticesCount < _notices.length)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _showMoreNotices,
                        icon: const Icon(Icons.arrow_downward,
                            color: Colors.white),
                        label: const Text(
                          'View more',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          backgroundColor: Colors.green[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 5,
                        ),
                      ),
                    )
                ],
              ),
            ),
    );
  }
}

// Model for Notice
class Notice {
  final String date;
  final String time;
  final String name;
  final String subject;
  final String content;

  Notice({
    required this.date,
    required this.time,
    required this.name,
    required this.subject,
    required this.content,
  });
}

class NoticeButton extends StatelessWidget {
  final String date;
  final String time;
  final String name;
  final String subject;
  final String content;
  final String daysAgo;
  final VoidCallback onPressed;

  const NoticeButton({
    super.key,
    required this.date,
    required this.time,
    required this.name,
    required this.subject,
    required this.content,
    required this.daysAgo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(0),
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name : $subject',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 53, 133, 56),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      daysAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoticeDetailPage extends StatelessWidget {
  final String subject;
  final String content;
  final String name;
  final String date;
  final String time;

  const NoticeDetailPage({
    super.key,
    required this.subject,
    required this.content,
    required this.name,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          subject,
          style: const TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: Container(
        color: Colors.green[50],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From: $name',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 18, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.access_time,
                            size: 18, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Share.share(
                          'Notice from $name\n\nSubject: $subject\n\n$content');
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
