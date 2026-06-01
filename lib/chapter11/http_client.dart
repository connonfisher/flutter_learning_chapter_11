// 来源：https://book.flutterchina.club/chapter11/http.html
// 功能说明：演示如何使用 Dart 内置的 dart:io HttpClient 发起 HTTP 请求。
// 该示例完整实现 HttpClient 的五步通信流程：
//   1) 创建 HttpClient
//   2) 打开连接并设置请求头（User-Agent 等）
//   3) 等待连接服务器并获取响应
//   4) 通过 utf8.decoder 读取响应流为字符串
//   5) 关闭 HttpClient
// 实例：请求百度首页 HTML 并显示返回内容（去除空白字符以节省屏幕空间）。

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class MyHttpOverrides extends HttpOverrides {}

class HttpTestRoute extends StatefulWidget {
  const HttpTestRoute({super.key});

  @override
  State<HttpTestRoute> createState() => _HttpTestRouteState();
}

class _HttpTestRouteState extends State<HttpTestRoute> {
  bool _loading = false;
  String _text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('11.2 HttpClient 请求')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _loading ? null : request,
              child: const Text("获取百度首页"),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50.0,
              child: Text(_text.replaceAll(RegExp(r"\s"), "")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> request() async {
    setState(() {
      _loading = true;
      _text = "正在请求...";
    });
    try {
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.getUrl(
        Uri.parse("https://www.baidu.com"),
      );
      request.headers.add(
        "user-agent",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) "
            "AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 "
            "Mobile/14E304 Safari/602.1",
      );
      HttpClientResponse response = await request.close();
      _text = await response.transform(utf8.decoder).join();
      debugPrint(response.headers.toString());
      httpClient.close();
    } catch (e) {
      _text = "请求失败：$e";
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MaterialApp(home: HttpTestRoute()));
}
