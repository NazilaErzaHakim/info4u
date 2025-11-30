import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:info4u/providers/galeri_provider.dart';
import 'galeri_add_screen.dart';
import 'galeri_update_screen.dart';

class GaleriScreen extends ConsumerWidget {
  const GaleriScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galeri = ref.watch(galeriProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Galeri", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GaleriAddScreen()),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),

      body: galeri.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada data galeri"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final item = list[i];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        item["fotoUrl"],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    ListTile(
                      title: Text(
                        item["judul"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Kategori: ${item["kategori"]}\n"
                        "Tanggal: ${item["tanggal"] ?? '-'}\n"
                        "Uploaded By: ${item["uploadedBy"]}",
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
                                builder: (_) => GaleriUpdateScreen(
                                  id: item["id"],
                                  data: item,
                                ),
                              ),
                            );
                          } else if (value == "delete") {
                            ref
                                .read(galeriProvider.notifier)
                                .deleteGaleri(item["id"]);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 10),
                                Text("Edit"),
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
                                Icon(Icons.cancel, color: Colors.grey),
                                SizedBox(width: 10),
                                Text("Close"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
