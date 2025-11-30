import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/ekskul_provider.dart';

class EkskulUpdateScreen extends ConsumerStatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EkskulUpdateScreen({super.key, required this.id, required this.data});

  @override
  ConsumerState<EkskulUpdateScreen> createState() => _EkskulUpdateScreenState();
}

class _EkskulUpdateScreenState extends ConsumerState<EkskulUpdateScreen> {
  final namaController = TextEditingController();
  final pembinaController = TextEditingController();
  final jadwalController = TextEditingController();
  final deskripsiController = TextEditingController();
  final fotoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaController.text = widget.data["namaEkskul"] ?? "";
    pembinaController.text = widget.data["pembina"] ?? "";
    jadwalController.text = widget.data["jadwal"] ?? "";
    deskripsiController.text = widget.data["deskripsi"] ?? "";
    fotoController.text = widget.data["fotoUrl"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(ekskulProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Update Ekskul",
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
            textField("Foto URL", fotoController),

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
                await provider.updateEkskul(widget.id, {
                  "namaEkskul": namaController.text,
                  "pembina": pembinaController.text,
                  "jadwal": jadwalController.text,
                  "deskripsi": deskripsiController.text,
                  "fotoUrl": fotoController.text,
                });

                Navigator.pop(context);
              },
              child: const Text("Update"),
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
