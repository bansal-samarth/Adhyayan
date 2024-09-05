import 'package:adhyayan/pages/pdfview.dart';
import 'package:flutter/material.dart';

class ChaptersPage extends StatelessWidget {
  final String subject;
  final String material;

  const ChaptersPage(
      {super.key, required this.subject, required this.material});

  @override
  Widget build(BuildContext context) {
    final chapters = ["Chapter 1", "Chapter 2", "Chapter 3", "Chapter 4"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          "$material - $subject",
          style:
              const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        // centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                      context,
                      (material == 'Book')
                          ? MaterialPageRoute(
                              builder: (context) => Pdfview(
                                    chapter: index,
                                    subject: subject,
                                    material: material,
                                  ))
                          : MaterialPageRoute(
                              builder: (context) => Pdfview(
                                    chapter: index,
                                    subject: subject,
                                    material: material,
                                  )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapters[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap to read',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
