import 'package:flutter/material.dart';

Widget _notAvailable(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            '此功能依赖 dart:io，\n暂不支持 Web 平台',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            '请在 Android / Windows / macOS 上运行',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

class FileOperationRoute extends StatelessWidget {
  const FileOperationRoute({super.key});
  @override
  Widget build(BuildContext context) => _notAvailable('11.1 文件操作');
}

class HttpTestRoute extends StatelessWidget {
  const HttpTestRoute({super.key});
  @override
  Widget build(BuildContext context) => _notAvailable('11.2 HttpClient');
}

class DownloadWithChunksRoute extends StatelessWidget {
  const DownloadWithChunksRoute({super.key});
  @override
  Widget build(BuildContext context) => _notAvailable('11.4 Http分块下载');
}

class SocketRoute extends StatelessWidget {
  const SocketRoute({super.key});
  @override
  Widget build(BuildContext context) => _notAvailable('11.6 Socket API');
}
