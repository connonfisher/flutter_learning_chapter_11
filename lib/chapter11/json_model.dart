// 来源：https://book.flutterchina.club/chapter11/json_model.html
// 功能说明：演示 JSON 字符串与 Dart Model 类之间的相互转换。
// 涵盖：
//   1) 直接通过 dart:convert 的 json.decode 将字符串解析为 Map/List
//   2) 定义 User Model 类，提供 fromJson 构造和 toJson 方法
//   3) 通过 User.fromJson 反序列化 + json.encode(user) 序列化的完整流程
// 注：书中后半部分介绍 json_serializable 自动生成 .g.dart 的方案，
//   本文件作为入门示例，仅使用最简单的"手写 fromJson/toJson"实现。

import 'dart:convert';
import 'package:flutter/material.dart';

/// 手写的 Model 类，等价于书中 user.dart 的简化版
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      email = json['email'];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'email': email,
  };
}

class JsonModelRoute extends StatefulWidget {
  const JsonModelRoute({super.key});

  @override
  State<JsonModelRoute> createState() => _JsonModelRouteState();
}

class _JsonModelRouteState extends State<JsonModelRoute> {
  String _output = "点击按钮查看 JSON 与 Model 转换结果";

  void _runDemo() {
    final buf = StringBuffer();

    // 1. 用 json.decode 直接解析为 List
    String jsonStr = '[{"name":"Jack"},{"name":"Rose"}]';
    List items = json.decode(jsonStr);
    buf.writeln('【1】json.decode 解析 List：');
    buf.writeln('  第一个用户姓名 = ${items[0]["name"]}');
    buf.writeln();

    // 2. 用 json.decode 解析为 Map
    String userJson = '{"name":"John Smith","email":"john@example.com"}';
    Map<String, dynamic> userMap = json.decode(userJson);
    buf.writeln('【2】json.decode 解析 Map：');
    buf.writeln('  Howdy, ${userMap['name']}!');
    buf.writeln('  email = ${userMap['email']}');
    buf.writeln();

    // 3. 通过 User.fromJson 转为 Model 类
    User user = User.fromJson(userMap);
    buf.writeln('【3】User.fromJson 转 Model：');
    buf.writeln('  user.name = ${user.name}');
    buf.writeln('  user.email = ${user.email}');
    buf.writeln();

    // 4. 通过 toJson + json.encode 序列化回字符串
    String encoded = json.encode(user);
    buf.writeln('【4】json.encode(user) 序列化：');
    buf.writeln('  $encoded');

    setState(() => _output = buf.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('11.7 JSON 转 Dart Model 类')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _runDemo,
              child: const Text('运行 JSON↔Model 演示'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: JsonModelRoute()));
