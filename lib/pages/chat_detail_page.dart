import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import 'video_call_page.dart';
import 'red_packet_page.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;

  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool _showEmojiPicker = false;
  bool _showMorePanel = false;
  bool _isVoiceMode = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    messages = List.from(mockMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _messageController.text.trim(),
        isMe: true,
        time: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        _showMorePanel = false;
      }
    });
  }

  void _toggleMorePanel() {
    setState(() {
      _showMorePanel = !_showMorePanel;
      if (_showMorePanel) {
        _showEmojiPicker = false;
      }
    });
  }

  void _insertEmoji(String emoji) {
    final text = _messageController.text;
    final selection = _messageController.selection;
    final newText = text.replaceRange(
      selection.start >= 0 ? selection.start : text.length,
      selection.end >= 0 ? selection.end : text.length,
      emoji,
    );
    _messageController.text = newText;
    _messageController.selection = TextSelection.collapsed(
      offset: newText.length,
    );
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('复制'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已复制')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.forward),
                title: const Text('转发'),
                onTap: () {
                  Navigator.pop(context);
                  _showForwardDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_border),
                title: const Text('收藏'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已收藏')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('编辑'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditMessageDialog(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('删除', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    messages.removeWhere((m) => m.id == message.id);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showForwardDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('转发给'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/100/100?random=$index',
                    ),
                  ),
                  title: Text('联系人 ${index + 1}'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('转发成功')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditMessageDialog(Message message) {
    final controller = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('编辑消息'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
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
                setState(() {
                  final index = messages.indexWhere((m) => m.id == message.id);
                  if (index != -1) {
                    messages[index] = Message(
                      id: message.id,
                      content: controller.text,
                      isMe: message.isMe,
                      time: message.time,
                    );
                  }
                });
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _sendMediaMessage(String type) {
    setState(() {
      messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: type == 'image' ? '[图片]' : type == 'video' ? '[视频]' : '[文件]',
        isMe: true,
        time: DateTime.now(),
        type: type == 'image' ? MessageType.image : MessageType.text,
      ));
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDED),
        foregroundColor: Colors.black,
        title: Text(widget.chat.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallPage(
                    userName: widget.chat.name,
                    userAvatar: widget.chat.avatar,
                    isVideo: true,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallPage(
                    userName: widget.chat.name,
                    userAvatar: widget.chat.avatar,
                    isVideo: false,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showChatSettings();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: Container(
              color: const Color(0xFFEDEDED),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(messages[index]);
                },
              ),
            ),
          ),
          // 输入框
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: const Color(0xFFF7F7F7),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isVoiceMode ? Icons.keyboard : Icons.mic,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVoiceMode = !_isVoiceMode;
                        });
                      },
                    ),
                    Expanded(
                      child: _isVoiceMode
                          ? GestureDetector(
                              onLongPressStart: (_) {
                                setState(() {
                                  _isRecording = true;
                                });
                              },
                              onLongPressEnd: (_) {
                                setState(() {
                                  _isRecording = false;
                                });
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isRecording ? Colors.grey[300] : Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _isRecording ? '松开发送' : '按住说话',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '输入消息...',
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showEmojiPicker ? Icons.keyboard : Icons.sentiment_satisfied_alt,
                        color: Colors.grey,
                      ),
                      onPressed: _toggleEmojiPicker,
                    ),
                    IconButton(
                      icon: Icon(
                        _showMorePanel ? Icons.keyboard : Icons.add_circle_outline,
                        color: Colors.grey,
                      ),
                      onPressed: _toggleMorePanel,
                    ),
                    if (!_showEmojiPicker && !_showMorePanel)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: TextButton(
                          onPressed: _sendMessage,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF1AAD19),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('发送', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                ),
                // 表情选择器
                if (_showEmojiPicker) _buildEmojiPicker(),
                // 更多功能面板
                if (_showMorePanel) _buildMorePanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isMe) ...[
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.chat.avatar),
              ),
              const SizedBox(width: 8),
            ],
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: message.isMe ? const Color(0xFF95EC69) : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(message.content),
            ),
            if (message.isMe) ...[
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = [
      '😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊', '😇', '🙂',
      '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', '😋', '😛',
      '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🤐', '🤨',
      '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥', '😌', '😔',
      '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤮', '🤧', '🥵',
      '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '😎', '🤓', '🧐', '😕',
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '💔', '💕', '💖',
      '👍', '👎', '👏', '🙌', '🤝', '🙏', '💪', '✌️', '🤞', '👋',
    ];

    return Container(
      height: 200,
      color: Colors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          childAspectRatio: 1,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _insertEmoji(emojis[index]),
            child: Center(
              child: Text(
                emojis[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMorePanel() {
    final items = [
      {'icon': Icons.photo, 'label': '图片', 'type': 'image'},
      {'icon': Icons.camera_alt, 'label': '拍摄', 'type': 'camera'},
      {'icon': Icons.videocam, 'label': '视频', 'type': 'video'},
      {'icon': Icons.location_on, 'label': '位置', 'type': 'location'},
      {'icon': Icons.card_giftcard, 'label': '红包', 'type': 'redpacket'},
      {'icon': Icons.card_giftcard, 'label': '转账', 'type': 'transfer'},
      {'icon': Icons.insert_drive_file, 'label': '文件', 'type': 'file'},
      {'icon': Icons.contact_phone, 'label': '名片', 'type': 'contact'},
    ];

    return Container(
      height: 200,
      color: const Color(0xFFF7F7F7),
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final type = items[index]['type'] as String;
              if (type == 'redpacket') {
                Navigator.pop(context);
                _showRedPacketDialog();
              } else {
                setState(() {
                  _showMorePanel = false;
                });
                _sendMediaMessage(type);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    items[index]['icon'] as IconData,
                    color: items[index]['type'] == 'redpacket' 
                        ? const Color(0xFFFA9D3B) 
                        : Colors.black87,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items[index]['label'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRedPacketDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const RedPacketPage(
          senderName: '我',
        );
      },
    );
  }

  void _showChatSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('查找聊天记录'),
                onTap: () {
                  Navigator.pop(context);
                  _showSearchDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('消息免打扰'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: const Icon(Icons.pin),
                title: const Text('置顶聊天'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text('查看${widget.chat.name}的资料'),
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('搜索聊天记录'),
          content: const TextField(
            decoration: InputDecoration(
              hintText: '输入关键词',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('搜索'),
            ),
          ],
        );
      },
    );
  }
}
