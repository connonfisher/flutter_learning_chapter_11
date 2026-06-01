// 来源：https://book.flutterchina.club/chapter11/download_with_chunks.html
// 功能说明：演示利用 HTTP 协议的 Range 请求头实现"分块多线程下载"。
// 实现思路：
//   1) 先请求第一个分块，通过响应头判断服务器是否支持分块 (HTTP 206)
//   2) 通过 Content-Range 解析文件总长度，进而计算剩余长度并切块
//   3) 多个分块并发下载到临时文件 (temp0、temp1...)
//   4) 全部完成后合并临时文件并删除中间文件
// 本示例提供一个简单 UI：输入下载 URL，点击开始即可看到下载进度。

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadWithChunksRoute extends StatefulWidget {
  const DownloadWithChunksRoute({super.key});

  @override
  State<DownloadWithChunksRoute> createState() =>
      _DownloadWithChunksRouteState();
}

class _DownloadWithChunksRouteState extends State<DownloadWithChunksRoute> {
  final TextEditingController _urlController = TextEditingController(
    text: "https://www.baidu.com/img/flexible/logo/pc/result.png",
  );
  String _status = "等待开始...";
  double _progress = 0;

  Future<void> _startDownload() async {
    setState(() {
      _status = "正在下载...";
      _progress = 0;
    });
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/download_result.bin";
      await downloadWithChunks(
        _urlController.text,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
              _status = "${(_progress * 100).floor()}% (已保存到 $savePath)";
            });
          }
        },
      );
      setState(() => _status = "下载完成，文件位于：$savePath");
    } catch (e) {
      setState(() => _status = "下载失败：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('11.4 Http 分块下载')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: '下载链接'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startDownload,
              child: const Text('开始分块下载'),
            ),
            const SizedBox(height: 24),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}

/// 分块下载实现（核心算法）
Future<void> downloadWithChunks(
  String url,
  String savePath, {
  ProgressCallback? onReceiveProgress,
}) async {
  const firstChunkSize = 102;
  const maxChunk = 3;

  int total = 0;
  var dio = Dio();
  var progress = <int>[];

  ProgressCallback createCallback(int no) {
    return (int received, int _) {
      progress[no] = received;
      if (onReceiveProgress != null && total != 0) {
        onReceiveProgress(progress.reduce((a, b) => a + b), total);
      }
    };
  }

  Future<Response> downloadChunk(
    String url,
    int start,
    int end,
    int no,
  ) async {
    progress.add(0);
    --end;
    return dio.download(
      url,
      "${savePath}temp$no",
      onReceiveProgress: createCallback(no),
      options: Options(headers: {"range": "bytes=$start-$end"}),
    );
  }

  Future<void> mergeTempFiles(int chunk) async {
    File f = File("${savePath}temp0");
    IOSink ioSink = f.openWrite(mode: FileMode.writeOnlyAppend);
    for (int i = 1; i < chunk; ++i) {
      File f2 = File("${savePath}temp$i");
      await ioSink.addStream(f2.openRead());
      await f2.delete();
    }
    await ioSink.close();
    await f.rename(savePath);
  }

  Response response = await downloadChunk(url, 0, firstChunkSize, 0);
  if (response.statusCode == 206) {
    total = int.parse(
      response.headers
          .value(HttpHeaders.contentRangeHeader)!
          .split("/")
          .last,
    );
    int reserved =
        total -
        int.parse(response.headers.value(HttpHeaders.contentLengthHeader)!);
    int chunk = (reserved / firstChunkSize).ceil() + 1;
    if (chunk > 1) {
      int chunkSize = firstChunkSize;
      if (chunk > maxChunk + 1) {
        chunk = maxChunk + 1;
        chunkSize = (reserved / maxChunk).ceil();
      }
      var futures = <Future>[];
      for (int i = 0; i < maxChunk; ++i) {
        int start = firstChunkSize + i * chunkSize;
        futures.add(downloadChunk(url, start, start + chunkSize, i + 1));
      }
      await Future.wait(futures);
    }
    await mergeTempFiles(chunk);
  }
}

void main() => runApp(const MaterialApp(home: DownloadWithChunksRoute()));
