import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pengumuman_provider.dart';
import 'pengumuman_add_screen.dart';
import 'pengumuman_update_screen.dart';

class PengumumanScreen extends ConsumerWidget {
  const PengumumanScreen({super.key});

  void showOption(BuildContext context, String id, Map data, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text("Update"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengumumanUpdateScreen(
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
              ref.read(pengumumanProvider.notifier).deletePengumuman(id);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(color: Colors.white),
        title: const Text(
          "Pengumuman",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PengumumanAddScreen()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),

      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: ref.read(pengumumanProvider.notifier).streamPengumuman(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data!;

          if (list.isEmpty) {
            return const Center(child: Text("Belum ada pengumuman"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (_, index) {
              final doc = list[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GAMBAR
                      if (data["gambarUrl"] != null && data["gambarUrl"] != "")
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data["gambarUrl"],
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          height: 160,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image, size: 60),
                        ),

                      const SizedBox(height: 10),

                      // JUDUL
                      Text(
                        data["judul"] ?? "-",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // KATEGORI
                      Text(
                        "Kategori: ${data["kategori"] ?? "-"}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // DESKRIPSI
                      Text(
                        "Deskripsi: ${data["deskripsi"] ?? "-"}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // INFO TAMBAHAN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Oleh: ${data["dibuatOleh"] ?? "-"}"),
                          Text(
                            "Tanggal: ${(data["tanggal"] as Timestamp).toDate().toString().split(' ')[0]}",
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // CREATED & UPDATED
                      Text(
                        "Dibuat: ${(data["createdAt"] as Timestamp?)?.toDate().toString().split(' ')[0] ?? "-"}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Update: ${(data["updateAt"] as Timestamp?)?.toDate().toString().split(' ')[0] ?? "-"}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () =>
                              showOption(context, doc.id, data, ref),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
