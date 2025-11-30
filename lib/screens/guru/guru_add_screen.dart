import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/guru_provider.dart';

class GuruAddScreen extends ConsumerWidget {
  final TextEditingController cNip = TextEditingController();
  final TextEditingController cNama = TextEditingController();
  final TextEditingController cMapel = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cNoHp = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Guru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField(controller: cNip, label: "NIP"),
            const SizedBox(height: 16),
            buildTextField(controller: cNama, label: "Nama"),
            const SizedBox(height: 16),
            buildTextField(controller: cMapel, label: "Mata Pelajaran"),
            const SizedBox(height: 16),
            buildTextField(controller: cEmail, label: "Email"),
            const SizedBox(height: 16),
            buildTextField(controller: cNoHp, label: "No HP"),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await ref
                    .read(guruProvider.notifier)
                    .addGuru(
                      nama: cNama.text,
                      nip: cNip.text,
                      mapel: cMapel.text,
                      email: cEmail.text,
                      noHp: cNoHp.text,
                      fotoUrl: '', // default kosong
                    );
                Navigator.pop(context);
              },
              child: const Text(
                "Tambah",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
