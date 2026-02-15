import 'package:flutter/material.dart';

class Moment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final List<String> images;
  final String time;
  final String location;
  final int likes;
  final List<Comment> comments;

  Moment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.images = const [],
    required this.time,
    this.location = '',
    this.likes = 0,
    this.comments = const [],
  });
}

class Comment {
  final String userName;
  final String content;
  final String? replyTo;

  Comment({
    required this.userName,
    required this.content,
    this.replyTo,
  });
}

// 模拟朋友圈数据
List<Moment> mockMoments = [
  Moment(
    id: '1',
    userName: '张三',
    userAvatar: 'https://picsum.photos/100/100?random=1',
    content: '今天天气真好，出来走走～',
    images: [
      'https://picsum.photos/400/300?random=20',
      'https://picsum.photos/400/300?random=21',
    ],
    time: '2小时前',
    location: '北京·朝阳公园',
    likes: 12,
    comments: [
      Comment(userName: '李四', content: '风景不错啊！'),
      Comment(userName: '王五', content: '下次带上我'),
    ],
  ),
  Moment(
    id: '2',
    userName: '小明',
    userAvatar: 'https://picsum.photos/100/100?random=5',
    content: '周末愉快！🎉',
    images: [
      'https://picsum.photos/400/300?random=22',
    ],
    time: '5小时前',
    likes: 8,
    comments: [
      Comment(userName: '小红', content: '同乐同乐~'),
    ],
  ),
  Moment(
    id: '3',
    userName: '小红',
    userAvatar: 'https://picsum.photos/100/100?random=16',
    content: '新书到了，准备开始学习！📚',
    time: '昨天',
    location: '北京·中关村',
    likes: 25,
    comments: [
      Comment(userName: '张三', content: '什么书？推荐一下'),
      Comment(userName: '小明', content: '加油！', replyTo: '小红'),
    ],
  ),
  Moment(
    id: '4',
    userName: '王五',
    userAvatar: 'https://picsum.photos/100/100?random=3',
    content: '今天完成了一个大项目，辛苦了这么久终于可以休息一下了。',
    images: [
      'https://picsum.photos/400/300?random=23',
      'https://picsum.photos/400/300?random=24',
      'https://picsum.photos/400/300?random=25',
    ],
    time: '昨天',
    likes: 35,
    comments: [
      Comment(userName: '李四', content: '恭喜恭喜！'),
    ],
  ),
];

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: CustomScrollView(
        slivers: [
          // 顶部封面和用户信息
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFEDEDED),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/800/400?random=cover',
                    fit: BoxFit.cover,
                  ),
                  // 用户信息
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        const Text(
                          '我的昵称',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/100/100?random=100',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 朋友圈列表
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildMomentItem(mockMoments[index]);
              },
              childCount: mockMoments.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentItem(Moment moment) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(moment.userAvatar),
          ),
          const SizedBox(width: 12),
          // 内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名
                Text(
                  moment.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF576B95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                // 文字内容
                Text(
                  moment.content,
                  style: const TextStyle(fontSize: 15),
                ),
                // 图片
                if (moment.images.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildImagesGrid(moment.images),
                ],
                // 时间和位置
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      moment.time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (moment.location.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      Text(
                        moment.location,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                    const Spacer(),
                    // 操作按钮
                    _buildActionButtons(moment),
                  ],
                ),
                // 点赞和评论
                if (moment.likes > 0 || moment.comments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 点赞
                        if (moment.likes > 0)
                          Row(
                            children: [
                              const Icon(Icons.favorite, size: 14, color: Colors.red),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${moment.likes}人赞',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF576B95),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // 评论
                        if (moment.comments.isNotEmpty) ...[
                          if (moment.likes > 0) const SizedBox(height: 6),
                          ...moment.comments.map((comment) => _buildComment(comment)),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesGrid(List<String> images) {
    if (images.length == 1) {
      return GestureDetector(
        onTap: () => _showImagePreview(images, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            images[0],
            width: 180,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    int crossAxisCount = images.length == 2 ? 2 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length > 9 ? 9 : images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImagePreview(images, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black),
          children: [
            TextSpan(
              text: comment.userName,
              style: const TextStyle(color: Color(0xFF576B95)),
            ),
            if (comment.replyTo != null) ...[
              const TextSpan(text: ' 回复 '),
              TextSpan(
                text: comment.replyTo,
                style: const TextStyle(color: Color(0xFF576B95)),
              ),
            ],
            const TextSpan(text: '：'),
            TextSpan(text: comment.content),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Moment moment) {
    return GestureDetector(
      onTap: () => _showActionSheet(moment),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_horiz, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Icon(Icons.message, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showActionSheet(Moment moment) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.favorite_border, '赞', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已点赞')),
                );
              }),
              _buildActionButton(Icons.comment, '评论', () {
                Navigator.pop(context);
                _showCommentDialog(moment);
              }),
              _buildActionButton(Icons.share, '转发', () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('转发成功')),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showCommentDialog(Moment moment) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('评论'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '写下你的评论...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
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
                  const SnackBar(content: Text('评论成功')),
                );
              },
              child: const Text('发送'),
            ),
          ],
        );
      },
    );
  }

  void _showImagePreview(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewPage(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class ImagePreviewPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImagePreviewPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1}/${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              child: Image.network(
                widget.images[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
