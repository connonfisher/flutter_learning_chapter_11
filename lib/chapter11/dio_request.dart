// 来源：https://book.flutterchina.club/chapter11/dio.html
// 功能说明：演示如何使用 dio 这个第三方 HTTP 请求库发起网络请求。
// 相比 HttpClient，dio 提供了更简洁的 API，并内置支持拦截器、FormData、
// 文件下载、Cookie 管理等高级特性。
// 实例：通过 GitHub 开放 API 请求 flutterchina 组织下的所有公开仓库，
//   - 请求进行中显示 CircularProgressIndicator
//   - 请求出错时显示错误信息
//   - 请求成功后以 ListView 形式展示仓库 full_name 列表

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioRequestRoute extends StatefulWidget {
  const DioRequestRoute({super.key});

  @override
  State<DioRequestRoute> createState() => _DioRequestRouteState();
}

class _DioRequestRouteState extends State<DioRequestRoute> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('11.3 Dio 请求')),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              Response response = snapshot.data;
              return ListView(
                children: response.data
                    .map<Widget>(
                      (e) => ListTile(title: Text(e["full_name"])),
                    )
                    .toList(),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: DioRequestRoute()));
