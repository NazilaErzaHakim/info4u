import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/siswa_provider.dart';
import 'siswa_add_screen.dart';
import 'siswa_update_screen.dart';

class SiswaScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siswaData = ref.watch(siswaProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Kelola Siswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SiswaAddScreen()),
              );
            },
          ),
        ],
      ),

      body: siswaData.when(
        data: (list) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final s = list[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(
                    s["nama"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("NIS: ${s['nis']}\nKelas: ${s['kelas']}"),
                  isThreeLine: true,

                  // ----------------------
                  //   TITIK 3 (POPUP MENU)
                  // ----------------------
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SiswaUpdateScreen(siswaId: s["id"], data: s),
                          ),
                        );
                      } else if (value == "delete") {
                        ref.read(siswaProvider.notifier).deleteSiswa(s["id"]);
                      } else if (value == "close") {
                        Navigator.pop(context);
                      }
                    },
                    itemBuilder: (context) => [
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

        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
