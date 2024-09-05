// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdfview extends StatefulWidget {
  final int chapter;
  final String subject;
  final String material;
  const Pdfview(
      {super.key,
      required this.chapter,
      required this.subject,
      required this.material});

  @override
  State<Pdfview> createState() => _PdfviewState();
}

class _PdfviewState extends State<Pdfview> {
  String sub = "";
  String url = 'https://xeonryzen.s3.amazonaws.com/8/';
  @override
  void initState() {
    super.initState();
    if (widget.material == 'Book') {
      if (widget.subject == 'MATHEMATICS') {
        sub = 'math';
      } else if (widget.subject == 'SOCIAL STUDIES') {
        sub = 'sst';
      } else if (widget.subject == 'SCIENCE') {
        sub = 'science';
      } else if (widget.subject == 'ENGLISH') {
        sub = 'english';
      } else if (widget.subject == 'HINDI') {
        sub = 'hindi';
      }

      url =
          "https://xeonryzen.s3.amazonaws.com/8/$sub/chapter${widget.chapter + 1}.pdf";
    } else if (widget.material == 'PPT') {
      if (widget.subject == 'MATHEMATICS') {
        sub = 'math';
      } else if (widget.subject == 'SOCIAL STUDIES')
        sub = 'sst';
      else if (widget.subject == 'SCIENCE')
        sub = 'science';
      else if (widget.subject == 'ENGLISH')
        sub = 'english';
      else if (widget.subject == 'HINDI') sub = 'hindi';

      url =
          "https://xeonryzen.s3.amazonaws.com/8/$sub/chapterppt${widget.chapter + 1}.pdf";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF View'),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
