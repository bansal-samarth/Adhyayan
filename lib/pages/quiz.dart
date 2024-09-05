import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> mcqDataList;

  const QuizPage({super.key, required this.mcqDataList});

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0; // Track the score
  bool? isCorrect;
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentQuestion =
        widget.mcqDataList[currentQuestionIndex];
    String question = currentQuestion['question'];
    List<String> options = List<String>.from(currentQuestion['options']);
    String correctAnswer = currentQuestion['correct_answer'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'MCQ Quiz',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 24,
          ),
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
              Text(
                question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ...options.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: _getButtonColor(option, correctAnswer),
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
                      child: TextButton(
                        onPressed: selectedOption == null
                            ? () {
                                setState(() {
                                  isCorrect = option == correctAnswer;
                                  selectedOption = option;
                                  if (isCorrect!) {
                                    score++; // Increment score if correct
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        isCorrect! ? 'Correct!' : 'Incorrect!'),
                                    backgroundColor:
                                        isCorrect! ? Colors.green : Colors.red,
                                  ),
                                );
                              }
                            : null,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 18),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
              if (selectedOption != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCorrect!
                            ? 'Great job!'
                            : 'The correct answer is: $correctAnswer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isCorrect! ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (currentQuestionIndex < widget.mcqDataList.length - 1)
                        Container(
                          width:
                              double.infinity, // Make the "Next" button larger
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
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentQuestionIndex++;
                                isCorrect = null;
                                selectedOption =
                                    null; // Reset for the next question
                              });
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: [
                            Text(
                              'Your score is $score/${widget.mcqDataList.length}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double
                                  .infinity, // Make the "Finish" button larger
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
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Finish',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

  // Determine the color of the button based on the option selected
  Color _getButtonColor(String option, String correctAnswer) {
    if (selectedOption == null) {
      return Colors.green; // Default color
    } else if (option == correctAnswer) {
      return Colors.green; // Correct answer in green
    } else {
      return Colors.red; // Incorrect answers in red
    }
  }
}
