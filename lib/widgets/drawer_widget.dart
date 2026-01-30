import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import UserProvider

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mengambil status login dari UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Text(
                  'Komiku Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home_outlined,
            text: 'Home',
            route: '/home',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.category_outlined,
            text: 'Kategori',
            route: '/categories',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.search_outlined,
            text: 'Cari Komik',
            route: '/searchComic',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.add_circle_outline,
            text: 'Tambah Komik',
            route: '/addComic',
          ),
          _buildDrawerItem(
            context,
            icon: Icons.edit_outlined,
            text: 'Kelola Komik',
            route: '/listComic',
          ),
          const Divider(),
          // Menampilkan item logout hanya jika pengguna sudah login
          if (userProvider.isLoggedIn) 
            _buildDrawerItem(
              context,
              icon: Icons.logout_outlined,
              text: 'Logout',
              route: '/login',
              isLogout: true,
            ),
          // Menampilkan item login jika belum login
          if (!userProvider.isLoggedIn) 
            _buildDrawerItem(
              context,
              icon: Icons.login_outlined,
              text: 'Login',
              route: '/login',
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.greenAccent),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        if (isLogout) {
          _logout(context);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void _logout(BuildContext context) {
    // Implementasi logout dengan memanggil method logout dari UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
