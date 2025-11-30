import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pengumuman_provider.dart';

class PengumumanAddScreen extends ConsumerWidget {
  final TextEditingController cJudul = TextEditingController();
  final TextEditingController cDeskripsi = TextEditingController();
  final TextEditingController cKategori = TextEditingController();
  final TextEditingController cDibuatOleh = TextEditingController();
  final TextEditingController cGambarUrl = TextEditingController();

  final ValueNotifier<DateTime> tgl = ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(color: Colors.white),
        title: const Text(
          "Tambah Pengumuman",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input(cJudul, "Judul"),
              _input(cDeskripsi, "Deskripsi", maxLines: 3),
              _input(cKategori, "Kategori"),
              _input(cDibuatOleh, "Dibuat Oleh"),
              _input(cGambarUrl, "Gambar URL"),

              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: tgl,
                builder: (context, value, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tanggal: ${value.toLocal()}".split(' ')[0]),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (newDate != null) tgl.value = newDate;
                      },
                      child: const Text("Pilih Tanggal"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                ),
                onPressed: () async {
                  await ref
                      .read(pengumumanProvider.notifier)
                      .addPengumuman(
                        judul: cJudul.text,
                        description: cDeskripsi.text,
                        kategori: cKategori.text,
                        dibuatOleh: cDibuatOleh.text,
                        gambarUrl: cGambarUrl.text,
                        tanggal: tgl.value,
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
      ),
    );
  }

  Widget _input(TextEditingController c, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
