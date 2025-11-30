import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GuruScreenAdd extends StatefulWidget {
  const GuruScreenAdd({super.key});

  @override
  State<GuruScreenAdd> createState() => _GuruScreenAddState();
}

class _GuruScreenAddState extends State<GuruScreenAdd> {
  final CollectionReference guruRef = FirebaseFirestore.instance.collection(
    'guru',
  );

  void showAddGuruDialog() {
    final namaController = TextEditingController();
    final nipController = TextEditingController();
    final mapelController = TextEditingController();
    final emailController = TextEditingController();
    final noHpController = TextEditingController();
    final fotoUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Guru"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: nipController,
                decoration: const InputDecoration(labelText: "NIP"),
              ),
              TextField(
                controller: mapelController,
                decoration: const InputDecoration(labelText: "Mapel"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: noHpController,
                decoration: const InputDecoration(labelText: "No HP"),
              ),
              TextField(
                controller: fotoUrlController,
                decoration: const InputDecoration(labelText: "Foto URL"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // tombol biru
            ),
            onPressed: () async {
              if (namaController.text.isEmpty ||
                  fotoUrlController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Nama dan Foto URL wajib diisi"),
                  ),
                );
                return;
              }

              await guruRef.add({
                "nama": namaController.text,
                "nip": nipController.text,
                "mapel": mapelController.text,
                "email": emailController.text,
                "noHp": noHpController.text,
                "fotoUrl": fotoUrlController.text,
              });

              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void showOption(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Delete"),
            onTap: () async {
              Navigator.pop(context);
              await guruRef.doc(id).delete();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Guru"),
        backgroundColor: Colors.blue, // header biru
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: showAddGuruDialog),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: guruRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final listGuru = snapshot.data!.docs;

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
                final data = listGuru[index].data()! as Map<String, dynamic>;
                final fotoUrl = data["fotoUrl"] ?? "";

                return Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              child: fotoUrl.isNotEmpty
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
                                onPressed: () =>
                                    showOption(context, listGuru[index].id),
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
        },
      ),
    );
  }
}
