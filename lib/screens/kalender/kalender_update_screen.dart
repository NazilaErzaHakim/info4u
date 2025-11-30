import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/kalender_provider.dart';

class KalenderUpdateScreen extends ConsumerStatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const KalenderUpdateScreen({super.key, required this.id, required this.data});

  @override
  ConsumerState<KalenderUpdateScreen> createState() =>
      _KalenderUpdateScreenState();
}

class _KalenderUpdateScreenState extends ConsumerState<KalenderUpdateScreen> {
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final tipeController = TextEditingController();

  String? tglMulai;
  String? tglSelesai;

  @override
  void initState() {
    super.initState();
    namaController.text = widget.data["namaKegiatan"];
    deskripsiController.text = widget.data["deskripsi"];
    tipeController.text = widget.data["tipe"];

    tglMulai = widget.data["tanggalMulai"];
    tglSelesai = widget.data["tanggalSelesai"];
  }

  Future<void> pilihTanggal(bool isMulai) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        final tgl = "${picked.day}-${picked.month}-${picked.year}";
        if (isMulai) {
          tglMulai = tgl;
        } else {
          tglSelesai = tgl;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(kalenderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Kegiatan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Kegiatan"),
            ),

            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),

            TextField(
              controller: tipeController,
              decoration: const InputDecoration(labelText: "Tipe"),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: Text(tglMulai ?? "Pilih Tanggal Mulai"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pilihTanggal(true),
            ),

            ListTile(
              title: Text(tglSelesai ?? "Pilih Tanggal Selesai"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pilihTanggal(false),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await provider.updateKalender(widget.id, {
                  "namaKegiatan": namaController.text,
                  "deskripsi": deskripsiController.text,
                  "tipe": tipeController.text,
                  "tanggalMulai": tglMulai,
                  "tanggalSelesai": tglSelesai,
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
}
