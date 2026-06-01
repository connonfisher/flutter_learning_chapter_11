// 章节总目录入口：
// 复现《Flutter 实战·第二版》第 11 章「文件操作与网络请求」全部 7 个小节。
// 首页以 Card 列表的形式展示所有小节，点击即可跳转到对应演示页面；
// 每个小节文件也可独立运行（文件末尾都附带 main() 入口）。

import 'dart:io';
import 'package:flutter/material.dart';

import 'chapter11/file_operation.dart';
import 'chapter11/http_client.dart';
import 'chapter11/dio_request.dart';
import 'chapter11/download_with_chunks.dart';
import 'chapter11/websocket_demo.dart';
import 'chapter11/socket_demo.dart';
import 'chapter11/json_model.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 第11章 学习复现',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class _SectionItem {
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
  const _SectionItem(this.title, this.subtitle, this.builder);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<_SectionItem> _sections = [
    _SectionItem(
      '11.1 文件操作',
      'path_provider · File · 读写持久化',
      (_) => const FileOperationRoute(),
    ),
    _SectionItem(
      '11.2 Http 请求 - HttpClient',
      'dart:io · HttpClient · 请求百度首页',
      (_) => const HttpTestRoute(),
    ),
    _SectionItem(
      '11.3 Http 请求 - Dio',
      'Dio · FutureBuilder · GitHub API',
      (_) => const DioRequestRoute(),
    ),
    _SectionItem(
      '11.4 Http 分块下载',
      'Range Header · 多线程下载 · 临时文件合并',
      (_) => const DownloadWithChunksRoute(),
    ),
    _SectionItem(
      '11.5 WebSocket',
      'web_socket_channel · StreamBuilder · 实时回显',
      (_) => const WebSocketRoute(),
    ),
    _SectionItem(
      '11.6 使用 Socket API',
      'dart:io Socket · 手写 HTTP GET 请求',
      (_) => const SocketRoute(),
    ),
    _SectionItem(
      '11.7 JSON 转 Dart Model 类',
      'json.decode/encode · fromJson · toJson',
      (_) => const JsonModelRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 第11章 · 文件操作与网络请求'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final item = _sections[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(item.subtitle),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: item.builder),
              ),
            ),
          );
        },
      ),
    );
  }
}
