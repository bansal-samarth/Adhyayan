import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  final List<Map<String, String>> userData = const [
    {"Username": "Aarav_8_KV_01", "Password": "9876543210"},
    {"Username": "Diya_8_KV_02", "Password": "9765432109"},
    {"Username": "Ishaan_8_KV_03", "Password": "8765432198"},
    {"Username": "Aditi_8_KV_04", "Password": "7654321987"},
    {"Username": "Rohan_8_KV_05", "Password": "9123456789"},
    {"Username": "Simran_8_KV_06", "Password": "7612345678"},
    {"Username": "Aditya_8_KV_07", "Password": "9098765432"},
    {"Username": "Kavya_8_KV_08", "Password": "8976543210"},
    {"Username": "Aryan_8_KV_09", "Password": "9876512340"},
    {"Username": "Neha_8_KV_10", "Password": "7654398765"},
    {"Username": "Rajesh_9_KV_01", "Password": "8765412398"},
    {"Username": "Priya_9_KV_02", "Password": "8934567210"},
    {"Username": "Sahil_9_KV_03", "Password": "7634512398"},
    {"Username": "Nikita_9_KV_04", "Password": "7523416789"},
    {"Username": "Vikram_9_KV_05", "Password": "9023456789"},
    {"Username": "Anjali_9_KV_06", "Password": "9045612398"},
    {"Username": "Karan_9_KV_07", "Password": "7890123456"},
    {"Username": "Meera_9_KV_08", "Password": "8976512340"},
    {"Username": "Aman_9_KV_09", "Password": "8956234109"},
    {"Username": "Riya_9_KV_10", "Password": "7843209876"},
    {"Username": "Sneha_10_KV_01", "Password": "9098723450"},
    {"Username": "Rajat_10_KV_02", "Password": "8967234567"},
    {"Username": "Riya_10_KV_03", "Password": "7623459876"},
    {"Username": "Mohit_10_KV_04", "Password": "9876543219"},
    {"Username": "Tanya_10_KV_05", "Password": "7890654321"},
    {"Username": "Arjun_10_KV_06", "Password": "8945612345"},
    {"Username": "Maya_10_KV_07", "Password": "8345612987"},
  ];

  Future<void> _uploadData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    for (var user in userData) {
      await users.doc(user["Username"]).set({
        "username": user["Username"],
        "password": user["Password"],
      });
    }

    // ignore: avoid_print
    print("Data upload complete");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload User Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _uploadData,
          child: const Text('Upload Data to Firestore'),
        ),
      ),
    );
  }
}
