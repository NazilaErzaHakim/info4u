import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/siswa_provider.dart';

class SiswaAddScreen extends ConsumerWidget {
  final TextEditingController cNis = TextEditingController();
  final TextEditingController cNama = TextEditingController();
  final TextEditingController cKelas = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cNoHp = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tambah Siswa",
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
                await ref
                    .read(siswaProvider.notifier)
                    .addSiswa(
                      nis: cNis.text,
                      nama: cNama.text,
                      kelas: cKelas.text,
                      email: cEmail.text,
                      noHp: cNoHp.text,
                    );
                Navigator.pop(context);
              },
              child: const Text(
                "Tambah",
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
