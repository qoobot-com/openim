import 'package:flutter/material.dart';

class VideoCallPage extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final bool isVideo;

  const VideoCallPage({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.isVideo = true,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _isMuted = false;
  bool _isSpeaker = true;
  bool _isCameraOff = false;
  bool _isConnected = false;
  int _callDuration = 0;

  @override
  void initState() {
    super.initState();
    // 模拟连接延迟
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
        _startCallTimer();
      }
    });
  }

  void _startCallTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isConnected) {
        setState(() {
          _callDuration++;
        });
        _startCallTimer();
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _endCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 背景（对方的画面）
          if (widget.isVideo)
            Positioned.fill(
              child: Container(
                color: Colors.grey[900],
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(widget.userAvatar),
                  ),
                ),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[800]!,
                      Colors.grey[900]!,
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.userAvatar),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isConnected
                          ? _formatDuration(_callDuration)
                          : '正在呼叫...',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // 自己的小画面（画中画）
          if (widget.isVideo)
            Positioned(
              top: 80,
              right: 16,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _isCameraOff
                      ? Container(
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(
                              Icons.person_off,
                              color: Colors.white54,
                              size: 40,
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[600],
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white54,
                              size: 40,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          // 顶部信息栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.call, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.isVideo ? '视频通话' : '语音通话',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const Spacer(),
                    if (_isConnected)
                      Text(
                        _formatDuration(_callDuration),
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // 底部控制栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? '取消静音' : '静音',
                      isActive: _isMuted,
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                    ),
                    if (widget.isVideo)
                      _buildControlButton(
                        icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
                        label: _isCameraOff ? '打开摄像头' : '关闭摄像头',
                        isActive: _isCameraOff,
                        onPressed: () {
                          setState(() {
                            _isCameraOff = !_isCameraOff;
                          });
                        },
                      ),
                    _buildControlButton(
                      icon: _isSpeaker ? Icons.volume_up : Icons.volume_off,
                      label: _isSpeaker ? '扬声器' : '听筒',
                      onPressed: () {
                        setState(() {
                          _isSpeaker = !_isSpeaker;
                        });
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.call_end,
                      label: '挂断',
                      isEndCall: true,
                      onPressed: _endCall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    bool isEndCall = false,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isEndCall
                  ? Colors.red
                  : isActive
                      ? Colors.white
                      : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isEndCall
                  ? Colors.white
                  : isActive
                      ? Colors.black
                      : Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
