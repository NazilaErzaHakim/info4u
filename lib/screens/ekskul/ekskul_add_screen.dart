import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/ekskul_provider.dart';

class EkskulAddScreen extends ConsumerStatefulWidget {
  const EkskulAddScreen({super.key});

  @override
  ConsumerState<EkskulAddScreen> createState() => _EkskulAddScreenState();
}

class _EkskulAddScreenState extends ConsumerState<EkskulAddScreen> {
  final namaController = TextEditingController();
  final pembinaController = TextEditingController();
  final jadwalController = TextEditingController();
  final deskripsiController = TextEditingController();
  final fotoController = TextEditingController(); // isi link foto

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(ekskulProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Tambah Ekskul",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            textField("Nama Ekskul", namaController),
            textField("Pembina", pembinaController),
            textField("Jadwal", jadwalController),
            textField("Deskripsi", deskripsiController, maxLines: 3),
            textField("Foto URL (opsional)", fotoController),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
              ),
              onPressed: () async {
                await provider.addEkskul({
                  "namaEkskul": namaController.text,
                  "pembina": pembinaController.text,
                  "jadwal": jadwalController.text,
                  "deskripsi": deskripsiController.text,
                  "fotoUrl": fotoController.text,
                });

                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
