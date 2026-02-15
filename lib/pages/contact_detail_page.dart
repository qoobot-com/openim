import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'chat_detail_page.dart';
import '../models/chat.dart';

class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDED),
        foregroundColor: Colors.black,
        title: const Text('详细资料'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 用户信息卡片
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(contact.avatar),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '微信号: wx_${contact.id}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      if (contact.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          contact.subtitle!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 功能列表
          _buildMenuItem(Icons.circle, '朋友圈', showArrow: true),
          _buildMenuItem(Icons.video_library, '视频动态'),
          const SizedBox(height: 8),
          _buildMenuItem(Icons.more_horiz, '更多信息'),
          const SizedBox(height: 8),
          // 发消息按钮
          Container(
            color: Colors.white,
            child: TextButton(
              onPressed: () {
                // 创建一个临时的Chat对象并跳转到聊天页面
                final chat = Chat(
                  id: contact.id,
                  name: contact.name,
                  avatar: contact.avatar,
                  lastMessage: '',
                  time: '',
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailPage(chat: chat),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1AAD19),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('发消息', style: TextStyle(fontSize: 16)),
            ),
          ),
          Container(
            color: Colors.white,
            child: TextButton(
              onPressed: () {
                _showCallDialog(context, '语音通话');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1AAD19),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('语音通话', style: TextStyle(fontSize: 16)),
            ),
          ),
          Container(
            color: Colors.white,
            child: TextButton(
              onPressed: () {
                _showCallDialog(context, '视频通话');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1AAD19),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('视频通话', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool showArrow = false}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.star_border),
                title: const Text('设为星标朋友'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已设为星标朋友')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('加入黑名单', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已加入黑名单')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_problem, color: Colors.red),
                title: const Text('投诉', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCallDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(type),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(contact.avatar),
              ),
              const SizedBox(height: 16),
              Text(
                '正在呼叫 ${contact.name}...',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }
}
