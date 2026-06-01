// 来源：https://book.flutterchina.club/chapter11/websocket.html
// 功能说明：演示如何使用 web_socket_channel 库与 WebSocket 服务器实时通信。
// WebSocket 通信四步：
//   1) 连接到 WebSocket 服务器 (IOWebSocketChannel.connect)
//   2) 通过 StreamBuilder 监听 channel.stream 接收消息
//   3) 通过 channel.sink.add(...) 发送消息
//   4) 在 dispose 时 channel.sink.close() 关闭连接
// 实例：连接 wss://echo.websocket.events 测试服务，发送任意文本后
//   服务端会原样回显，UI 上以 "echo: xxx" 形式展示。

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketRoute extends StatefulWidget {
  const WebSocketRoute({super.key});

  @override
  State<WebSocketRoute> createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> {
  final TextEditingController _controller = TextEditingController();
  late IOWebSocketChannel channel;
  String _text = "";

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('wss://echo.websocket.events');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("11.5 WebSocket (内容回显)")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: '发送一条消息'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  _text = "网络不通...";
                } else if (snapshot.hasData) {
                  _text = "echo: ${snapshot.data}";
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(_text),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: '发送消息',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

void main() => runApp(const MaterialApp(home: WebSocketRoute()));
