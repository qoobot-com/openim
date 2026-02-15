import 'package:flutter/material.dart';
import '../models/chat.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Chat> _filteredChats = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredChats = mockChats;
  }

  void _filterChats(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredChats = mockChats;
      } else {
        _filteredChats = mockChats
            .where((chat) =>
                chat.name.toLowerCase().contains(query.toLowerCase()) ||
                chat.lastMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // 模拟刷新数据
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 搜索框
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFFEDEDED),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterChats,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '搜索',
                  prefixIcon: Icon(Icons.search, size: 20),
                  prefixIconConstraints: BoxConstraints(minWidth: 32),
                ),
              ),
            ),
          ),
          // 聊天列表
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: _filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = _filteredChats[index];
                  return _buildChatItem(context, chat);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatOptions();
        },
        backgroundColor: const Color(0xFF1AAD19),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Chat chat) {
    return Dismissible(
      key: Key(chat.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.done, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmDialog(context, chat);
        } else {
          // 标记为已读
          setState(() {
            chat.unreadCount;
          });
          return false;
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(chat: chat),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // 头像
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(chat.avatar),
                  ),
                  if (chat.unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18),
                        child: Text(
                          chat.unreadCount > 99 ? '99+' : '${chat.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          chat.time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, Chat chat) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除聊天'),
          content: Text('确定要删除与 ${chat.name} 的聊天记录吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add, color: Color(0xFF1AAD19)),
                title: const Text('添加朋友'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddFriendDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_add, color: Color(0xFF1AAD19)),
                title: const Text('创建群聊'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('创建群聊')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner, color: Color(0xFF1AAD19)),
                title: const Text('扫一扫'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('扫一扫')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddFriendDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加朋友'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '微信号/手机号',
              prefixIcon: Icon(Icons.search),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('搜索用户')),
                );
              },
              child: const Text('搜索'),
            ),
          ],
        );
      },
    );
  }
}
