import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDED),
        foregroundColor: Colors.black,
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 账号与安全
          _buildSection([
            _buildMenuItem(Icons.lock, '账号与安全'),
          ]),
          // 通用设置
          _buildSection([
            _buildMenuItem(Icons.notifications, '新消息通知', showArrow: true),
            _buildMenuItem(Icons.privacy_tip, '隐私'),
            _buildMenuItem(Icons.widgets, '通用'),
          ]),
          // 其他设置
          _buildSection([
            _buildMenuItem(Icons.help_outline, '帮助与反馈'),
            _buildMenuItem(Icons.info_outline, '关于微信'),
          ]),
          // 底部操作
          const SizedBox(height: 16),
          Container(
            color: Colors.white,
            child: TextButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('退出登录', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
          // 版本信息
          const Center(
            child: Text(
              '版本 8.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool showArrow = false, Widget? trailing}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF576B95), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          if (trailing != null) trailing,
          if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('退出登录'),
          content: const Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已退出登录')),
                );
              },
              child: const Text('确定', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
