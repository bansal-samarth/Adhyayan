import 'package:adhyayan/pages/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'chapters.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  String? selectedSubject;

  late List<String> subjects;
  late List<String> materials;

  final List<String> images = [
    "assets/sub/math.jpg",
    "assets/sub/sst.jpg",
    "assets/sub/sci.jpg",
    "assets/sub/eng.jpg",
    "assets/sub/hin.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Initialize with default values
    subjects = ["MATHEMATICS", "SOCIAL STUDIES", "SCIENCE", "ENGLISH", "HINDI"];
    materials = ["Book", "PPT", "Video"];

    // Update with localized strings after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLocalizedLists();
    });
  }

  void _updateLocalizedLists() {
    setState(() {
      subjects = [
        AppLocalizations.of(context)!.math,
        AppLocalizations.of(context)!.sst,
        AppLocalizations.of(context)!.science,
        AppLocalizations.of(context)!.english,
        AppLocalizations.of(context)!.hindi,
      ];
      materials = [
        AppLocalizations.of(context)!.book,
        AppLocalizations.of(context)!.ppt,
        AppLocalizations.of(context)!.video,
      ];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.library,
          style:
              const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Column(
              children: subjects.asMap().entries.map((entry) {
                int index = entry.key;
                String subject = entry.value;
                bool isSelected = selectedSubject == subject;
                return AnimatedSize(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSubject = isSelected ? null : subject;
                      });
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.03,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                          image: DecorationImage(
                            image: AssetImage(images[index]),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop),
                          ),
                        ),
                        child: isSelected
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: materials.map((material) {
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          material ==
                                                  AppLocalizations.of(context)!
                                                      .video
                                              ? MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlaybackPage(
                                                    subject: subjects[index],
                                                  ),
                                                )
                                              : (material ==
                                                      AppLocalizations.of(
                                                              context)!
                                                          .book)
                                                  ? MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChaptersPage(
                                                        subject: subject,
                                                        material: material,
                                                      ),
                                                    )
                                                  : MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChaptersPage(
                                                            subject: subject,
                                                            material: material,
                                                          )),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                            topLeft: material == materials.first
                                                ? const Radius.circular(15)
                                                : Radius.zero,
                                            topRight: material == materials.last
                                                ? const Radius.circular(15)
                                                : Radius.zero,
                                            bottomLeft:
                                                material == materials.first
                                                    ? const Radius.circular(15)
                                                    : Radius.zero,
                                            bottomRight:
                                                material == materials.last
                                                    ? const Radius.circular(15)
                                                    : Radius.zero,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            material,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : Container(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    subject,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
