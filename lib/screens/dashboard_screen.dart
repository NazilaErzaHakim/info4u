import 'package:flutter/material.dart';
import 'package:info4u/screens/guru/guru_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),

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
            // === HEADER DIPERKECIL ===
            SizedBox(
              height: 57, // kecilin tingginya di sini (default 200)
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
            _drawerItem(context, Icons.photo_album, 'Galeri Foto', '/galeri'),
            _drawerItem(
              context,
              Icons.admin_panel_settings,
              'User Roles',
              '/user',
            ),
          ],
        ),
      ),

      // -----------------------
      // BODY DASHBOARD NORMAL
      // -----------------------
      body: SingleChildScrollView(
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
                  total: 23,
                  icon: Icons.person,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                _dashboardCard(
                  title: "Siswa",
                  total: 210,
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
                  total: 12,
                  icon: Icons.campaign,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 16),
                _dashboardCard(
                  title: "Ekskul",
                  total: 8,
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

  // -------------------------
  // ITEM DI SIDEBAR (DRAWER)
  // -------------------------
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String text,
    String route,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade300, // border biru
          width: 0.8, // border diperkecil
        ),
        borderRadius: BorderRadius.circular(10), // sudut sedikit melengkung
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 26), // ikon biru 💙
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

  // -------------------------
  // CARD DASHBOARD
  // -------------------------
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
