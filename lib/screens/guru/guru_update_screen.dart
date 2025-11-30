import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuruUpdateScreen extends ConsumerWidget {
  final String guruId;
  final Map<String, dynamic> data;

  GuruUpdateScreen({super.key, required this.guruId, required this.data});

  final TextEditingController cNip = TextEditingController();
  final TextEditingController cNama = TextEditingController();
  final TextEditingController cMapel = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cNoHp = TextEditingController();
  final TextEditingController cFotoUrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    cNip.text = data["nip"] ?? "";
    cNama.text = data["nama"] ?? "";
    cMapel.text = data["mapel"] ?? "";
    cEmail.text = data["email"] ?? "";
    cNoHp.text = data["noHp"] ?? "";
    cFotoUrl.text = data["fotoUrl"] ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Update Guru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Back button putih
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cNip,
              decoration: const InputDecoration(labelText: 'NIP'),
            ),
            TextField(
              controller: cNama,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: cMapel,
              decoration: const InputDecoration(labelText: 'Mata Pelajaran'),
            ),
            TextField(
              controller: cEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: cNoHp,
              decoration: const InputDecoration(labelText: 'No HP'),
            ),
            TextField(
              controller: cFotoUrl,
              decoration: const InputDecoration(labelText: 'Foto URL'),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("guru")
                      .doc(guruId)
                      .update({
                        "nip": cNip.text,
                        "nama": cNama.text,
                        "mapel": cMapel.text,
                        "email": cEmail.text,
                        "noHp": cNoHp.text,
                        "fotoUrl": cFotoUrl.text,
                      });

                  Navigator.pop(context);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
