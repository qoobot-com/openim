class Chat {
  final String id;
  final String name;
  final String avatar;
  String lastMessage;
  String time;
  int unreadCount;

  Chat({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? avatar,
    String? lastMessage,
    String? time,
    int? unreadCount,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// 模拟聊天数据
List<Chat> mockChats = [
  Chat(
    id: '1',
    name: '张三',
    avatar: 'https://picsum.photos/100/100?random=1',
    lastMessage: '今天晚上一起吃饭吗？',
    time: '12:30',
    unreadCount: 2,
  ),
  Chat(
    id: '2',
    name: '李四',
    avatar: 'https://picsum.photos/100/100?random=2',
    lastMessage: '项目文档已经发给你了',
    time: '11:20',
    unreadCount: 0,
  ),
  Chat(
    id: '3',
    name: '王五',
    avatar: 'https://picsum.photos/100/100?random=3',
    lastMessage: '好的，明天见',
    time: '昨天',
    unreadCount: 0,
  ),
  Chat(
    id: '4',
    name: '工作群',
    avatar: 'https://picsum.photos/100/100?random=4',
    lastMessage: '[图片]',
    time: '昨天',
    unreadCount: 5,
  ),
  Chat(
    id: '5',
    name: '小明',
    avatar: 'https://picsum.photos/100/100?random=5',
    lastMessage: '周末有空吗？',
    time: '周一',
    unreadCount: 0,
  ),
  Chat(
    id: '6',
    name: '家庭群',
    avatar: 'https://picsum.photos/100/100?random=6',
    lastMessage: '妈妈：今天回来吃饭吗',
    time: '周日',
    unreadCount: 3,
  ),
];
