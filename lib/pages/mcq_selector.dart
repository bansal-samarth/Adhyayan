import 'package:adhyayan/models/mcq_generator.dart';
import 'package:adhyayan/pages/quiz.dart';
import 'package:flutter/material.dart';

class McqSelector extends StatelessWidget {
  final List<String> subjects = ['Math', 'English', 'SST', 'Science'];

  McqSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'MCQ Quiz',
          style: TextStyle(
              fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add the asset image at the top
              Image.asset(
                'assets/practice.png',
                width: 200,
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(
                  height: 20), // Add spacing between the image and buttons
              ...subjects
                  .map((subject) => _buildSubjectButton(context, subject)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectButton(BuildContext context, String subject) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextButton(
            onPressed: () {
              var mcqData = generateMCQ(subject);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(mcqDataList: mcqData),
                ),
              );
            },
            child: Text(
              subject,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
