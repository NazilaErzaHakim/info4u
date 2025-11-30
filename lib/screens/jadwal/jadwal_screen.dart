import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/jadwal_provider.dart';
import 'package:info4u/screens/jadwal/jadwal_add_screen.dart';
import 'package:info4u/screens/jadwal/jadwal_update_screen.dart';

class JadwalScreen extends ConsumerWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(color: Colors.white),
        title: const Text(
          "Jadwal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JadwalAddScreen()),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: ref.read(jadwalProvider.notifier).streamJadwal(),
        builder: (_, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());

          final list = snap.data!;
          if (list.isEmpty)
            return const Center(child: Text("Belum ada jadwal"));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final doc = list[i];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    "${data['mapel']} - ${data['kelas']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${data['hari']} • ${data['jamMulai']} - ${data['jamSelesai']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => showOption(context, doc.id, data, ref),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showOption(BuildContext context, String id, Map data, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Update"),
            onTap: () {
              Navigator.pop(context); // tutup bottomsheet dulu
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JadwalUpdateScreen(
                    id: id,
                    data: Map<String, dynamic>.from(data),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete"),
            onTap: () {
              Navigator.pop(context);
              ref.read(jadwalProvider.notifier).deleteJadwal(id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.grey),
            title: const Text("Close"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
