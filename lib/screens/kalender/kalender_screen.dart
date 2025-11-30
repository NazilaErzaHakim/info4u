import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/kalender_provider.dart';
import 'kalender_add_screen.dart';
import 'kalender_update_screen.dart';

class KalenderScreen extends ConsumerWidget {
  const KalenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kalender = ref.watch(kalenderProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Kalender Kegiatan",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KalenderAddScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),

      body: kalender.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text("Belum ada kegiatan", style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final item = list[i];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(
                    item["namaKegiatan"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "${item["tanggalMulai"]} - ${item["tanggalSelesai"]}\n"
                      "Tipe: ${item["tipe"]}\n"
                      "Deskripsi: ${item["deskripsi"]}",
                    ),
                  ),

                  trailing: PopupMenuButton(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) async {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => KalenderUpdateScreen(
                              id: item["id"],
                              data: item,
                            ),
                          ),
                        );
                      } else if (value == "delete") {
                        await ref
                            .read(kalenderProvider.notifier)
                            .deleteKalender(item["id"]);
                      } else if (value == "close") {
                        Navigator.pop(context); // menutup popup menu
                      }
                    },

                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("Update"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10),
                            Text("Delete"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: "close",
                        child: Row(
                          children: [
                            Icon(Icons.close, color: Colors.grey),
                            SizedBox(width: 10),
                            Text("Close"),
                          ],
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
