import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF), // Biru muda lembut
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        title: const Text(
          'Info4U – Beranda',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _menuItem(
              context,
              icon: Icons.campaign,
              label: 'Pengumuman',
              color: const Color(0xFF42A5F5),
              route: '/pengumuman',
            ),

            _menuItem(
              context,
              icon: Icons.school,
              label: 'Profil Sekolah',
              color: const Color(0xFF64B5F6),
              route: '/profil',
            ),

            _menuItem(
              context,
              icon: Icons.person,
              label: 'Data Guru',
              color: const Color(0xFF1976D2),
              route: '/guru',
            ),

            _menuItem(
              context,
              icon: Icons.group,
              label: 'Data Siswa',
              color: const Color(0xFF0D47A1),
              route: '/siswa',
            ),

            _menuItem(
              context,
              icon: Icons.schedule,
              label: 'Jadwal Pelajaran',
              color: const Color(0xFF2196F3),
              route: '/jadwal',
            ),

            _menuItem(
              context,
              icon: Icons.calendar_month,
              label: 'Kalender Akademik',
              color: const Color(0xFF42A5F5),
              route: '/kalender',
            ),

            _menuItem(
              context,
              icon: Icons.sports_soccer,
              label: 'Ekskul',
              color: const Color(0xFF1565C0),
              route: '/ekskul',
            ),

            _menuItem(
              context,
              icon: Icons.photo_album,
              label: 'Album Foto',
              color: const Color(0xFF1E88E5),
              route: '/galeri',
            ),

            _menuItem(
              context,
              icon: Icons.admin_panel_settings,
              label: 'User Roles',
              color: const Color(0xFF0D47A1),
              route: '/user',
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required Color color,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 48),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
