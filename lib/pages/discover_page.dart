import 'package:flutter/material.dart';
import 'moments_page.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildMenuItem(Icons.circle, '朋友圈', color: const Color(0xFF576B95), onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MomentsPage()),
            );
          }),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.video_library, '视频号', color: const Color(0xFFFF9C00)),
          _buildMenuItem(Icons.live_tv, '直播', color: const Color(0xFF576B95)),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.search, '搜一搜', color: const Color(0xFFFF9C00)),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.people, '附近', color: const Color(0xFF576B95)),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.shopping_bag, '购物', color: const Color(0xFFFF9C00)),
          _buildMenuItem(Icons.games, '游戏', color: const Color(0xFF576B95)),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.access_time, '小程序', color: const Color(0xFF576B95)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color color = Colors.green, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
