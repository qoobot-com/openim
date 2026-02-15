import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'contact_detail_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String _selectedLetter = '';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];
  
  // 分组后的联系人
  final Map<String, List<Contact>> _groupedContacts = {};
  final List<String> _letters = [];

  @override
  void initState() {
    super.initState();
    _groupContacts();
    _filteredContacts = mockContacts;
  }

  void _groupContacts() {
    // 模拟按拼音首字母分组
    final Map<String, List<Contact>> grouped = {};
    for (var contact in mockContacts) {
      String letter = contact.name.substring(0, 1).toUpperCase();
      if (!RegExp(r'[A-Z]').hasMatch(letter)) {
        letter = '#';
      }
      grouped.putIfAbsent(letter, () => []).add(contact);
    }
    
    // 排序
    final sortedKeys = grouped.keys.toList()..sort();
    _groupedContacts.clear();
    _letters.clear();
    for (var key in sortedKeys) {
      _groupedContacts[key] = grouped[key]!;
      _letters.add(key);
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = mockContacts;
        _groupContacts();
      } else {
        _filteredContacts = mockContacts
            .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        // 重新分组筛选后的结果
        _groupedContacts.clear();
        _letters.clear();
        final Map<String, List<Contact>> grouped = {};
        for (var contact in _filteredContacts) {
          String letter = contact.name.substring(0, 1).toUpperCase();
          if (!RegExp(r'[A-Z]').hasMatch(letter)) {
            letter = '#';
          }
          grouped.putIfAbsent(letter, () => []).add(contact);
        }
        final sortedKeys = grouped.keys.toList()..sort();
        for (var key in sortedKeys) {
          _groupedContacts[key] = grouped[key]!;
          _letters.add(key);
        }
      }
    });
  }

  void _scrollToLetter(String letter) {
    setState(() {
      _selectedLetter = letter;
    });
    
    // 计算滚动位置
    double offset = 0;
    bool found = false;
    for (var l in _letters) {
      if (l == letter) {
        found = true;
        break;
      }
      // 计算该组的头部高度 + 每个联系人项的高度
      offset += 30; // 分组头部高度
      offset += (_groupedContacts[l]?.length ?? 0) * 56; // 每个联系人项高度
      // 还要加上功能入口的高度
      offset += 4 * 56 + 50; // 4个功能入口 + 搜索框
    }
    
    if (found && _scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
    
    // 短暂显示选中的字母
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _selectedLetter = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                    onChanged: _filterContacts,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '搜索',
                      prefixIcon: Icon(Icons.search, size: 20),
                      prefixIconConstraints: BoxConstraints(minWidth: 32),
                    ),
                  ),
                ),
              ),
              // 功能入口
              _buildMenuItem(Icons.person_add, '新的朋友', showBadge: true),
              _buildMenuItem(Icons.group, '群聊'),
              _buildMenuItem(Icons.label, '标签'),
              _buildMenuItem(Icons.public, '公众号'),
              // 联系人列表
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _letters.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildContactCount();
                    }
                    final letter = _letters[index - 1];
                    final contacts = _groupedContacts[letter] ?? [];
                    return _buildLetterGroup(letter, contacts);
                  },
                ),
              ),
            ],
          ),
          // 字母索引侧边栏
          Positioned(
            right: 0,
            top: 100,
            bottom: 20,
            child: _buildLetterIndex(),
          ),
          // 选中字母提示
          if (_selectedLetter.isNotEmpty)
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _selectedLetter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Text(
        '${mockContacts.length} 位联系人',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Widget _buildLetterGroup(String letter, List<Contact> contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          color: const Color(0xFFEDEDED),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...contacts.map((contact) => _buildContactItem(contact)),
      ],
    );
  }

  Widget _buildLetterIndex() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localY = details.localPosition.dy;
        final itemHeight = box.size.height / _letters.length;
        final index = (localY / itemHeight).floor();
        if (index >= 0 && index < _letters.length) {
          _scrollToLetter(_letters[index]);
        }
      },
      onTapUp: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localY = details.localPosition.dy;
        final itemHeight = box.size.height / _letters.length;
        final index = (localY / itemHeight).floor();
        if (index >= 0 && index < _letters.length) {
          _scrollToLetter(_letters[index]);
        }
      },
      child: Container(
        width: 24,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _letters.map((letter) {
            final isSelected = _selectedLetter == letter;
            return GestureDetector(
              onTap: () => _scrollToLetter(letter),
              child: Container(
                width: 20,
                height: 16,
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? const Color(0xFF1AAD19) : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool showBadge = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1AAD19),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          if (showBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildContactItem(Contact contact) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetailPage(contact: contact),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(contact.avatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: const TextStyle(fontSize: 16)),
                  if (contact.subtitle != null)
                    Text(
                      contact.subtitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
