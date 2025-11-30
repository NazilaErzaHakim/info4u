import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int guru = 0;
  int siswa = 0;
  int pengumuman = 0;
  int ekskul = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    guru = await countData('guru');
    siswa = await countData('siswa');
    pengumuman = await countData('pengumuman');
    ekskul = await countData('ekskul');

    setState(() => loading = false);
  }

  Future<int> countData(String collection) async {
    final snap = await FirebaseFirestore.instance.collection(collection).get();
    return snap.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),

      // =============================
      //        APP BAR + SIDEBAR
      // =============================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 57,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF1E88E5)),
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Akses Cepat',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            _drawerItem(context, Icons.person, 'Kelola Guru', '/guru'),
            _drawerItem(context, Icons.group, 'Kelola Siswa', '/siswa'),
            _drawerItem(context, Icons.campaign, 'Pengumuman', '/pengumuman'),
            _drawerItem(context, Icons.schedule, 'Jadwal', '/jadwal'),
            _drawerItem(context, Icons.calendar_month, 'Kalender', '/kalender'),
            _drawerItem(context, Icons.sports_soccer, 'Ekskul', '/ekskul'),
            _drawerItem(context, Icons.photo_album, 'Galeri', '/galeri'),
            _drawerItem(
              context,
              Icons.admin_panel_settings,
              'User Roles',
              '/user',
            ),
          ],
        ),
      ),

      // =============================
      //             BODY
      // =============================
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ringkasan Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _dashboardCard(
                        title: "Guru",
                        total: guru,
                        icon: Icons.person,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _dashboardCard(
                        title: "Siswa",
                        total: siswa,
                        icon: Icons.group,
                        color: Colors.indigo,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _dashboardCard(
                        title: "Pengumuman",
                        total: pengumuman,
                        icon: Icons.campaign,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 16),
                      _dashboardCard(
                        title: "Ekskul",
                        total: ekskul,
                        icon: Icons.sports_soccer,
                        color: Colors.lightBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // =========================
  // ITEM DI SIDEBAR
  // =========================
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String text,
    String route,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 26),
        title: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  // =========================
  // CARD DASHBOARD
  // =========================
  Widget _dashboardCard({
    required String title,
    required int total,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "$total data",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class SingleChildScrollScrollView extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const SingleChildScrollScrollView({
    super.key,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: padding, child: child);
  }
}
