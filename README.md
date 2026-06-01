# Flutter 文件操作与网络请求

> 基于 [《Flutter 实战·第二版》第十一章](https://book.flutterchina.club/chapter11/) 的学习复现项目，完整覆盖文件持久化、HttpClient、Dio、分块下载、WebSocket、Socket API、JSON 序列化等核心机制。

## 环境信息

| 项目 | 版本 |
|------|------|
| Flutter | 3.41.4 |
| Dart | 3.11.1 |
| 主要依赖 | `path_provider`, `dio`, `web_socket_channel` |
| 支持平台 | Android / iOS / Web / Windows / macOS / Linux |

## 快速开始

```bash
git clone https://github.com/connonfisher/flutter_learning_chapter_11.git
cd flutter_learning_chapter_11
flutter pub get
flutter run
```

## 项目结构

```
lib/
├── main.dart                          # 章节目录导航页
└── chapter11/
    ├── file_operation.dart            # 11.1 文件操作
    ├── http_client.dart               # 11.2 Http请求-HttpClient
    ├── dio_request.dart               # 11.3 Http请求-Dio
    ├── download_with_chunks.dart      # 11.4 实例：Http分块下载
    ├── websocket_demo.dart            # 11.5 WebSocket
    ├── socket_demo.dart               # 11.6 使用Socket API
    └── json_model.dart                # 11.7 JSON转Dart Model类
```

每个小节文件均可独立运行（含 `main()` 入口），也可从首页目录导航进入。

## 目录导航主页

`main.dart` 提供章节总览入口，7 张卡片列出全部小节，点击即可导航进入对应页面。

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/目录导航-代码.png) | ![运行](assets/演示截图/目录导航-运行效果.png) |

### 核心实现

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<_SectionItem> _sections = [
    _SectionItem('11.1 文件操作', 'path_provider · File · 读写持久化',
        (_) => const FileOperationRoute()),
    _SectionItem('11.2 Http 请求 - HttpClient', 'dart:io · HttpClient · 请求百度首页',
        (_) => const HttpTestRoute()),
    // ... 共 7 个小节
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 第11章 · 文件操作与网络请求')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final item = _sections[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
```

---

## 11.1 文件操作

> 原文链接：[https://book.flutterchina.club/chapter11/file_operation.html](https://book.flutterchina.club/chapter11/file_operation.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `path_provider` | 获取应用沙盒目录（文档目录、临时目录、外部存储） |
| `dart:io` File | 文件读写：`readAsString()` / `writeAsString()` |
| `getApplicationDocumentsDirectory()` | 获取只有本应用可访问的持久化目录 |
| 计数器持久化 | 点击次数写入 `counter.txt`，重启后可恢复 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/11.1%20文件操作-代码.png) | ![运行](assets/演示截图/11.1%20文件操作-运行效果.png) |

### 核心代码示例

**获取文件路径 & 读取内容**

```dart
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
```

**写入文件（持久化计数）**

```dart
Future<void> _incrementCounter() async {
  setState(() { _counter++; });
  await (await _getLocalFile()).writeAsString('$_counter');
}
```

### 独立运行

```bash
flutter run -t lib/chapter11/file_operation.dart
```

---

## 11.2 Http请求-HttpClient

> 原文链接：[https://book.flutterchina.club/chapter11/http.html](https://book.flutterchina.club/chapter11/http.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `HttpClient` | `dart:io` 内置 HTTP 客户端，五步完成一次请求 |
| `HttpClientRequest` | 打开连接、设置请求头、发送请求体 |
| `HttpClientResponse` | 响应流通过 `utf8.decoder` 解码为字符串 |
| `HttpOverrides` | 全局注册以解决 Android API 36 上 `Platform._version` 兼容问题 |
| Basic/Digest 认证 | `addCredentials()` 添加用户凭据 |
| 代理 | `findProxy` 设置请求代理 |
| 证书校验 | `badCertificateCallback` 校验自签名证书 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/11.2%20Http请求-HttpClient-代码.png) | ![运行](assets/演示截图/11.2%20Http请求-HttpClient-运行效果.png) |

### 核心代码示例

**创建 HttpClient 并发起请求**

```dart
Future<void> request() async {
  HttpClient httpClient = HttpClient();
  // 打开连接
  HttpClientRequest request = await httpClient.getUrl(
    Uri.parse("https://www.baidu.com"),
  );
  // 设置请求头
  request.headers.add("user-agent", "Mozilla/5.0 ...");
  // 等待连接服务器
  HttpClientResponse response = await request.close();
  // 读取响应内容
  _text = await response.transform(utf8.decoder).join();
  // 关闭客户端
  httpClient.close();
}
```

**HttpOverrides 全局注册（解决 Android 兼容性）**

```dart
class MyHttpOverrides extends HttpOverrides {}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MaterialApp(home: HttpTestRoute()));
}
```

### 独立运行

```bash
flutter run -t lib/chapter11/http_client.dart
```

---

## 11.3 Http请求-Dio

> 原文链接：[https://book.flutterchina.club/chapter11/dio.html](https://book.flutterchina.club/chapter11/dio.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `Dio` | 强大简洁的 Dart HTTP 请求库，支持拦截器、FormData、文件上传/下载等 |
| `GET` / `POST` | `dio.get()` / `dio.post()`，支持 queryParameters 和 data 参数 |
| 并发请求 | `Future.wait([dio.post(...), dio.get(...)])` 同时发起多个请求 |
| 文件下载 | `dio.download(url, savePath)` |
| `FormData` | 支持 multipart/form-data 表单及多文件上传 |
| `FutureBuilder` | 异步请求与 UI 状态联动：Loading → 错误/成功 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/11.3%20Http请求-Dio-代码.png) | ![运行](assets/演示截图/11.3%20Http请求-Dio-运行效果.png) |

### 核心代码示例

**初始化 Dio 并请求 GitHub API**

```dart
final Dio _dio = Dio();

FutureBuilder(
  future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }
      Response response = snapshot.data;
      return ListView(
        children: response.data
            .map<Widget>((e) => ListTile(title: Text(e["full_name"])))
            .toList(),
      );
    }
    return const CircularProgressIndicator();
  },
)
```

**GET / POST / FormData 基本用法**

```dart
// GET
response = await dio.get("/test", queryParameters: {"id": 12, "name": "wendu"});

// POST
response = await dio.post("/test", data: {"id": 12, "name": "wendu"});

// 并发请求
response = await Future.wait([dio.post("/info"), dio.get("/token")]);

// FormData 上传
FormData formData = FormData.from({"name": "wendux", "age": 25});
response = await dio.post("/info", data: formData);
```

**配置代理 & 证书校验**

```dart
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  client.findProxy = (uri) => "PROXY 192.168.1.2:8888";
  client.badCertificateCallback = (cert, host, port) => cert.pem == PEM;
};
```

### 独立运行

```bash
flutter run -t lib/chapter11/dio_request.dart
```
