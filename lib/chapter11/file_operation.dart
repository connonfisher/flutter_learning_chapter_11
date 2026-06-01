// 来源：https://book.flutterchina.club/chapter11/file_operation.html
// 功能说明：演示 Flutter 中的文件读写操作。
// 使用 path_provider 插件获取应用文档目录，通过 dart:io 的 File 类实现
// "计数器持久化" —— 应用每次点击次数都会写入本地 counter.txt 文件，
// 重启应用后可以从文件恢复上次的计数，体现了 App 沙盒目录下持久化存储的基本流程。

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileOperationRoute extends StatefulWidget {
  const FileOperationRoute({super.key});

  @override
  State<FileOperationRoute> createState() => _FileOperationRouteState();
}

class _FileOperationRouteState extends State<FileOperationRoute> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/counter.txt');
  }

  Future<int> _readCounter() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await (await _getLocalFile()).writeAsString('$_counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('11.1 文件操作')),
      body: Center(
        child: Text('点击了 $_counter 次', style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: FileOperationRoute()));
