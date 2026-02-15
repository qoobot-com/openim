enum MessageType { text, image, voice }

class Message {
  final String id;
  final String content;
  final bool isMe;
  final DateTime time;
  final MessageType type;

  Message({
    required this.id,
    required this.content,
    required this.isMe,
    required this.time,
    this.type = MessageType.text,
  });
}

// 模拟消息数据
List<Message> mockMessages = [
  Message(
    id: '1',
    content: '你好，在吗？',
    isMe: false,
    time: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  Message(
    id: '2',
    content: '在的，有什么事吗？',
    isMe: true,
    time: DateTime.now().subtract(const Duration(minutes: 28)),
  ),
  Message(
    id: '3',
    content: '今天晚上一起吃饭吗？',
    isMe: false,
    time: DateTime.now().subtract(const Duration(minutes: 25)),
  ),
  Message(
    id: '4',
    content: '好啊，去哪里吃？',
    isMe: true,
    time: DateTime.now().subtract(const Duration(minutes: 20)),
  ),
  Message(
    id: '5',
    content: '公司附近新开了一家火锅店，听说不错',
    isMe: false,
    time: DateTime.now().subtract(const Duration(minutes: 18)),
  ),
  Message(
    id: '6',
    content: '可以的，几点？',
    isMe: true,
    time: DateTime.now().subtract(const Duration(minutes: 15)),
  ),
  Message(
    id: '7',
    content: '6点半怎么样？',
    isMe: false,
    time: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
];
