import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/ekskul_provider.dart';
import 'ekskul_add_screen.dart';
import 'ekskul_update_screen.dart';

class EkskulScreen extends ConsumerWidget {
  const EkskulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ekskulProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Data Ekskul", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EkskulAddScreen()),
              );
            },
          ),
        ],
      ),

      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada ekskul"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final item = list[i];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: item["fotoUrl"] != null
                        ? NetworkImage(item["fotoUrl"])
                        : null,
                    child: item["fotoUrl"] == null
                        ? const Icon(Icons.image_not_supported)
                        : null,
                  ),

                  title: Text(
                    item["namaEkskul"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    "Pembina: ${item["pembina"]}\n"
                    "Jadwal: ${item["jadwal"]}\n"
                    "Deskripsi: ${item["deskripsi"]}",
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
                            builder: (_) =>
                                EkskulUpdateScreen(id: item["id"], data: item),
                          ),
                        );
                      } else if (value == "delete") {
                        await ref
                            .read(ekskulProvider.notifier)
                            .deleteEkskul(item["id"]);
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
                      // 👉 MENU CLOSE DITAMBAHKAN DI SINI
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
