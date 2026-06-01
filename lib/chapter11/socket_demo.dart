// 来源：https://book.flutterchina.club/chapter11/socket.html
// 功能说明：演示如何使用 dart:io 中的 Socket API 直接基于 TCP 实现 HTTP GET 请求。
// Socket API 是操作系统对传输层协议（TCP/UDP）的封装，可用于自定义协议
// 或直接控制网络连接。本示例手动拼接 HTTP 协议报文（请求行 + Host 头 +
// Connection:close）发送到 baidu.com:80，再通过 utf8 解码读取完整响应
// （包含响应头 + 响应体），最终在 UI 上原样展示。

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class SocketRoute extends StatelessWidget {
  const SocketRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('11.6 使用 Socket API')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<String>(
          future: _request(),
          builder: (context, snapShot) {
            if (snapShot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            return Text(snapShot.data.toString());
          },
        ),
      ),
    );
  }

  Future<String> _request() async {
    var socket = await Socket.connect("baidu.com", 80);
    socket.writeln("GET / HTTP/1.1");
    socket.writeln("Host:baidu.com");
    socket.writeln("Connection:close");
    socket.writeln();
    await socket.flush();
    String response = await utf8.decoder.bind(socket).join();
    await socket.close();
    return response;
  }
}

void main() => runApp(const MaterialApp(home: SocketRoute()));
