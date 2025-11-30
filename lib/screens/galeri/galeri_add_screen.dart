import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:info4u/providers/galeri_provider.dart';

class GaleriAddScreen extends ConsumerStatefulWidget {
  const GaleriAddScreen({super.key});

  @override
  ConsumerState<GaleriAddScreen> createState() => _GaleriAddScreenState();
}

class _GaleriAddScreenState extends ConsumerState<GaleriAddScreen> {
  final judulController = TextEditingController();
  final kategoriController = TextEditingController();
  final uploadedByController = TextEditingController();

  File? imageFile;
  DateTime? tanggal;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      setState(() => imageFile = File(result.path));
    }
  }

  Future<String> uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("galeri/${DateTime.now().millisecondsSinceEpoch}.jpg");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => tanggal = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(galeriProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Tambah Galeri", style: TextStyle(color: Colors.white)),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: imageFile == null
                  ? const Icon(Icons.add_a_photo, size: 40)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(imageFile!, fit: BoxFit.cover),
                    ),
            ),
          ),

          const SizedBox(height: 20),
          TextField(controller: judulController, decoration: const InputDecoration(labelText: "Judul")),
          TextField(controller: kategoriController, decoration: const InputDecoration(labelText: "Kategori")),
          TextField(controller: uploadedByController, decoration: const InputDecoration(labelText: "Uploaded By")),

          const SizedBox(height: 20),

          ListTile(
            title: Text(tanggal == null
                ? "Pilih Tanggal"
                : "${tanggal!.day}-${tanggal!.month}-${tanggal!.year}"),
            trailing: const Icon(Icons.calendar_month),
            onTap: pilihTanggal,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () async {
              if (imageFile == null) return;

              final url = await uploadImage(imageFile!);

              await provider.addGaleri({
                "fotoUrl": url,
                "judul": judulController.text,
                "kategori": kategoriController.text,
                "uploadedBy": uploadedByController.text,
                "tanggal": tanggal?.toIso8601String(),
              });

              Navigator.pop(context);
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
