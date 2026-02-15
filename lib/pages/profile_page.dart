import 'package:flutter/material.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // 用户信息
          InkWell(
            onTap: () {
              _showEditProfileDialog(context);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://picsum.photos/100/100?random=100'),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('用户名', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        SizedBox(height: 4),
                        Text('微信号: wx_123456', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text('状态', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            SizedBox(width: 4),
                            Text('😄 在线', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.qr_code, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 功能列表
          _buildMenuItem(Icons.payment, '服务', color: const Color(0xFF4A90D9)),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.star, '收藏', color: Colors.yellow),
          _buildMenuItem(Icons.photo, '朋友圈', color: const Color(0xFF4A90D9)),
          _buildMenuItem(Icons.card_giftcard, '卡包', color: const Color(0xFF4A90D9)),
          _buildMenuItem(Icons.emoji_emotions, '表情', color: Colors.orange),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.settings, '设置', color: const Color(0xFF4A90D9), onTap: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color color = const Color(0xFF1AAD19), Function(BuildContext)? onTap}) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          if (onTap != null) {
            onTap(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('点击了 $title')),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16)),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      );
    });
  }

  void _showEditProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('个人信息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://picsum.photos/100/100?random=100'),
                ),
                title: const Text('更换头像'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('选择头像')),
                  );
                },
              ),
              ListTile(
                title: const Text('昵称'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('用户名', style: TextStyle(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () {
                  _showEditNameDialog(context);
                },
              ),
              ListTile(
                title: const Text('微信号'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('wx_123456', style: TextStyle(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              ListTile(
                title: const Text('个性签名'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('在线', style: TextStyle(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(text: '用户名');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('修改昵称'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入昵称',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('昵称已修改')),
                );
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
