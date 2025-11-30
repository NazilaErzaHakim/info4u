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

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SiswaUpdateScreen(siswaId: s["id"], data: s),
                            ),
                          );
                        },
                      ),

                      // Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(siswaProvider.notifier).deleteSiswa(s["id"]);
                        },
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
