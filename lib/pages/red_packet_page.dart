import 'package:flutter/material.dart';

class RedPacketPage extends StatefulWidget {
  final String? senderName;
  final String? senderAvatar;

  const RedPacketPage({
    super.key,
    this.senderName,
    this.senderAvatar,
  });

  @override
  State<RedPacketPage> createState() => _RedPacketPageState();
}

class _RedPacketPageState extends State<RedPacketPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpened = false;
  double _amount = 0;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openRedPacket() {
    setState(() {
      _isOpened = true;
      _amount = (1 + (DateTime.now().millisecond % 100)).toDouble();
      _message = '恭喜发财，大吉大利';
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            color: const Color(0xFFFA9D3B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部信息
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: widget.senderAvatar != null
                          ? NetworkImage(widget.senderAvatar!)
                          : null,
                      child: widget.senderAvatar == null
                          ? const Icon(Icons.person, size: 28)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.senderName ?? '微信红包',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '恭喜发财，大吉大利',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // 红包主体
              GestureDetector(
                onTap: _isOpened ? null : _openRedPacket,
                child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE75A4D),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: _isOpened
                        ? ScaleTransition(
                            scale: _animation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¥${_amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _message,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFA9D3B),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '開',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              // 关闭按钮
              Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 发红包页面
class SendRedPacketPage extends StatefulWidget {
  const SendRedPacketPage({super.key});

  @override
  State<SendRedPacketPage> createState() => _SendRedPacketPageState();
}

class _SendRedPacketPageState extends State<SendRedPacketPage> {
  final _amountController = TextEditingController();
  final _countController = TextEditingController(text: '1');
  final _messageController = TextEditingController(text: '恭喜发财，大吉大利');
  String _selectedType = 'random'; // random or fixed

  @override
  void dispose() {
    _amountController.dispose();
    _countController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendRedPacket() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的金额')),
      );
      return;
    }
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('红包已发送: ¥${amount.toStringAsFixed(2)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDED),
        foregroundColor: Colors.black,
        title: const Text('发红包'),
        actions: [
          TextButton(
            onPressed: _sendRedPacket,
            child: const Text('发送'),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 红包类型选择
                Row(
                  children: [
                    _buildTypeButton('拼手气红包', 'random'),
                    const SizedBox(width: 16),
                    _buildTypeButton('普通红包', 'fixed'),
                  ],
                ),
                const SizedBox(height: 24),
                // 金额输入
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('¥', style: TextStyle(fontSize: 24)),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                // 红包个数
                Row(
                  children: [
                    const Text('红包个数'),
                    const Spacer(),
                    const Text('共 '),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _countController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(' 个'),
                  ],
                ),
                const Divider(),
                // 留言
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '恭喜发财，大吉大利',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('余额: ', style: TextStyle(color: Colors.grey)),
                    const Text('¥999.99', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '红包金额200元以内，24小时内未领取将退款',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, String type) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFA9D3B) : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
