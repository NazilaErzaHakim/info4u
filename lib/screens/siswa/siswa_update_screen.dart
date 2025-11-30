import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SiswaUpdateScreen extends StatelessWidget {
  final String siswaId;
  final Map<String, dynamic> data;

  SiswaUpdateScreen({super.key, required this.siswaId, required this.data});

  final TextEditingController cNis = TextEditingController();
  final TextEditingController cNama = TextEditingController();
  final TextEditingController cKelas = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cNoHp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cNis.text = data["nis"];
    cNama.text = data["nama"];
    cKelas.text = data["kelas"];
    cEmail.text = data["email"];
    cNoHp.text = data["noHp"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Update Siswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cNis,
              decoration: const InputDecoration(labelText: "NIS"),
            ),
            TextField(
              controller: cNama,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: cKelas,
              decoration: const InputDecoration(labelText: "Kelas"),
            ),
            TextField(
              controller: cEmail,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: cNoHp,
              decoration: const InputDecoration(labelText: "No HP"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("siswa")
                    .doc(siswaId)
                    .update({
                      "nis": cNis.text,
                      "nama": cNama.text,
                      "kelas": cKelas.text,
                      "email": cEmail.text,
                      "noHp": cNoHp.text,
                    });

                Navigator.pop(context);
              },
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
