import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providerss/guru_provider.dart';

class GuruScreen extends StatelessWidget {
  const GuruScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GuruProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text("Data Guru", style: TextStyle(color: Colors.white)),
      ),

      body: StreamBuilder(
        stream: provider.getGuruStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data guru"));
          }

          final guruList = snapshot.data!;

          return ListView.builder(
            itemCount: guruList.length,
            itemBuilder: (context, index) {
              final guru = guruList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: (guru["fotoUrl"] != null &&
                            guru["fotoUrl"].toString().isNotEmpty)
                        ? NetworkImage(guru["fotoUrl"])
                        : const AssetImage("assets/noimage.png")
                            as ImageProvider,
                  ),
                  title: Text(guru["nama"]),
                  subtitle: Text("Mapel: ${guru["mapel"]}\nNIP: ${guru["nip"]}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
