import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/jadwal_provider.dart';

class JadwalAddScreen extends ConsumerStatefulWidget {
  const JadwalAddScreen({super.key});

  @override
  ConsumerState<JadwalAddScreen> createState() => _JadwalAddScreenState();
}

class _JadwalAddScreenState extends ConsumerState<JadwalAddScreen> {
  final guruController = TextEditingController();
  final hariController = TextEditingController();
  final mapelController = TextEditingController();
  final kelasController = TextEditingController();

  String? jamMulai;
  String? jamSelesai;

  Future<void> pilihJamMulai() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        jamMulai = picked.format(context);
      });
    }
  }

  Future<void> pilihJamSelesai() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        jamSelesai = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(jadwalProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Tambah Jadwal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 3,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _input(guruController, "Guru"),
            _input(hariController, "Hari"),
            _input(mapelController, "Mapel"),
            _input(kelasController, "Kelas"),

            const SizedBox(height: 15),

            // JAM MULAI
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.blue),
                title: Text(jamMulai ?? "Pilih Jam Mulai"),
                onTap: pilihJamMulai,
              ),
            ),

            // JAM SELESAI
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.blue),
                title: Text(jamSelesai ?? "Pilih Jam Selesai"),
                onTap: pilihJamSelesai,
              ),
            ),

            const SizedBox(height: 30),

            // BUTTON SIMPAN – Biru Border Biru Teks Putih
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  await provider.addJadwal({
                    "guru": guruController.text,
                    "hari": hariController.text,
                    "mapel": mapelController.text,
                    "kelas": kelasController.text,
                    "jamMulai": jamMulai,
                    "jamSelesai": jamSelesai,
                  });

                  Navigator.pop(context);
                },
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
