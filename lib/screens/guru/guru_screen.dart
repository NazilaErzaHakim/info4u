import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/guru_provider.dart';

class GuruScreen extends ConsumerWidget {
  const GuruScreen({super.key});

  void showOption(BuildContext context, String id, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Update"),
            onTap: () {
              // TODO: buat update screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Delete"),
            onTap: () {
              Navigator.pop(context);
              ref.read(guruProvider.notifier).deleteGuru(id);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text("Close"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: ref.read(guruProvider.notifier).streamGuru(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final listGuru = snapshot.data ?? [];

          if (listGuru.isEmpty) {
            return const Center(
              child: Text("Data Guru Kosong", style: TextStyle(fontSize: 16)),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: listGuru.length,
              itemBuilder: (context, index) {
                final data =
                    listGuru[index].data() as Map<String, dynamic>? ?? {};

                final fotoUrl = data["fotoUrl"] ?? "";

                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              child: fotoUrl != ""
                                  ? Image.network(
                                      fotoUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            print("Error load image: $error");
                                            return const Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 50,
                                              ),
                                            );
                                          },
                                    )
                                  : const Center(
                                      child: Icon(Icons.person, size: 50),
                                    ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onPressed: () => showOption(
                                  context,
                                  listGuru[index].id,
                                  ref,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["nama"] ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("NIP: ${data["nip"] ?? '-'}"),
                            Text("Mapel: ${data["mapel"] ?? '-'}"),
                            Text("Email: ${data["email"] ?? '-'}"),
                            Text("No HP: ${data["noHp"] ?? '-'}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
