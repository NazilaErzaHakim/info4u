import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/jadwal_provider.dart';

class JadwalUpdateScreen extends ConsumerStatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const JadwalUpdateScreen({super.key, required this.id, required this.data});

  @override
  ConsumerState<JadwalUpdateScreen> createState() => _JadwalUpdateScreenState();
}

class _JadwalUpdateScreenState extends ConsumerState<JadwalUpdateScreen> {
  final guruController = TextEditingController();
  final hariController = TextEditingController();
  final mapelController = TextEditingController();
  final kelasController = TextEditingController();

  String? jamMulai;
  String? jamSelesai;

  @override
  void initState() {
    super.initState();

    guruController.text = widget.data["guru"] ?? "";
    hariController.text = widget.data["hari"] ?? "";
    mapelController.text = widget.data["mapel"] ?? "";
    kelasController.text = widget.data["kelas"] ?? "";

    jamMulai = widget.data["jamMulai"] ?? "";
    jamSelesai = widget.data["jamSelesai"] ?? "";
  }

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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Update Jadwal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _inputField(guruController, "Guru"),
            _inputField(hariController, "Hari"),
            _inputField(mapelController, "Mapel"),
            _inputField(kelasController, "Kelas"),

            const SizedBox(height: 15),

            _timeTile(
              label: "Jam Mulai",
              value: jamMulai,
              onTap: pilihJamMulai,
            ),

            _timeTile(
              label: "Jam Selesai",
              value: jamSelesai,
              onTap: pilihJamSelesai,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await provider.updateJadwal(widget.id, {
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
                  "UPDATE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _timeTile({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        title: Text(
          value == null || value.isEmpty
              ? "$label (belum dipilih)"
              : "$label: $value",
          style: TextStyle(
            color: value == null || value.isEmpty ? Colors.grey : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.access_time, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }
}
