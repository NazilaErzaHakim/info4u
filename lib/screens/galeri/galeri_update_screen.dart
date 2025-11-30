import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:info4u/providers/galeri_provider.dart';

class GaleriUpdateScreen extends ConsumerStatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const GaleriUpdateScreen({super.key, required this.id, required this.data});

  @override
  ConsumerState<GaleriUpdateScreen> createState() => _GaleriUpdateScreenState();
}

class _GaleriUpdateScreenState extends ConsumerState<GaleriUpdateScreen> {
  final judulController = TextEditingController();
  final kategoriController = TextEditingController();
  final uploadedByController = TextEditingController();
  File? imageFile;
  DateTime? tanggal;
  String? fotoUrl;

  @override
  void initState() {
    super.initState();
    judulController.text = widget.data["judul"] ?? "";
    kategoriController.text = widget.data["kategori"] ?? "";
    uploadedByController.text = widget.data["uploadedBy"] ?? "";
    fotoUrl = widget.data["fotoUrl"];
    tanggal = DateTime.tryParse(widget.data["tanggal"] ?? "");
  }

  Future<void> pickImage() async {
    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() => imageFile = File(pick.path));
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
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: tanggal ?? DateTime.now(),
    );

    if (result != null) {
      setState(() => tanggal = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(galeriProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Update Galeri", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade200,
              ),
              child: imageFile != null
                  ? Image.file(imageFile!, fit: BoxFit.cover)
                  : fotoUrl != null
                      ? Image.network(fotoUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.add_a_photo, size: 40),
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
              String? link = fotoUrl;

              if (imageFile != null) {
                link = await uploadImage(imageFile!);
              }

              await provider.updateGaleri(widget.id, {
                "fotoUrl": link,
                "judul": judulController.text,
                "kategori": kategoriController.text,
                "uploadedBy": uploadedByController.text,
                "tanggal": tanggal?.toIso8601String(),
              });

              Navigator.pop(context);
            },
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
