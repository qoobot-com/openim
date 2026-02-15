class Contact {
  final String id;
  final String name;
  final String avatar;
  final String? subtitle;

  Contact({
    required this.id,
    required this.name,
    required this.avatar,
    this.subtitle,
  });
}

// 模拟联系人数据
List<Contact> mockContacts = [
  Contact(
    id: '1',
    name: '阿华',
    avatar: 'https://picsum.photos/100/100?random=10',
    subtitle: '专注前端开发',
  ),
  Contact(
    id: '2',
    name: '陈经理',
    avatar: 'https://picsum.photos/100/100?random=11',
  ),
  Contact(
    id: '3',
    name: '李四',
    avatar: 'https://picsum.photos/100/100?random=12',
  ),
  Contact(
    id: '4',
    name: '刘总',
    avatar: 'https://picsum.photos/100/100?random=13',
  ),
  Contact(
    id: '5',
    name: '小明',
    avatar: 'https://picsum.photos/100/100?random=14',
  ),
  Contact(
    id: '6',
    name: '王五',
    avatar: 'https://picsum.photos/100/100?random=15',
  ),
  Contact(
    id: '7',
    name: '小美',
    avatar: 'https://picsum.photos/100/100?random=16',
    subtitle: '热爱生活',
  ),
  Contact(
    id: '8',
    name: '张三',
    avatar: 'https://picsum.photos/100/100?random=17',
  ),
];
