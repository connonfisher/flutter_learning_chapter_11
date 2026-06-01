# Flutter 第 11 章 学习复现 · 文件操作与网络请求

> 基于《Flutter 实战·第二版》[第 11 章](https://book.flutterchina.club/chapter11/) 全部 7 个小节的代码复现与学习笔记。

## 📦 项目简介

本项目以 **「一节一文件」** 的方式逐节复现书中的示例代码，覆盖 Flutter 中常用的本地存储、HTTP 请求、WebSocket、Socket 以及 JSON 序列化等网络相关能力，每个小节既可以从总目录页跳转浏览，也可独立运行单文件。

### 🛠 环境信息

| 项目 | 版本 / 说明 |
| --- | --- |
| Flutter | 3.41.4 |
| Dart | 3.11.1 |
| 主要依赖 | `path_provider`, `dio`, `web_socket_channel` |
| 测试平台 | Android Emulator (Pixel 6 / API 36) |

### 🚀 快速开始

```bash
git clone https://github.com/connonfisher/Flutter_Learning_Chapter_11.git
cd Flutter_Learning_Chapter_11
flutter pub get
flutter run
```

### 📁 项目结构

```
flutter_learning_chapter_11/
├── lib/
│   ├── main.dart                          ← 章节总目录导航页
│   └── chapter11/
│       ├── file_operation.dart            ← 11.1 文件操作
│       ├── http_client.dart               ← 11.2 HttpClient
│       ├── dio_request.dart               ← 11.3 Dio
│       ├── download_with_chunks.dart      ← 11.4 Http 分块下载
│       ├── websocket_demo.dart            ← 11.5 WebSocket
│       ├── socket_demo.dart               ← 11.6 Socket API
│       └── json_model.dart                ← 11.7 JSON 转 Dart Model
├── assets/演示截图/                       ← 各小节代码与运行效果截图
├── pubspec.yaml
└── README.md
```

---

## 🗂 main.dart —— 章节总目录

`main.dart` 是整个项目的入口页面，使用 `ListView` + `Card` 渲染了全部 7 个小节卡片，点击任意一项即可通过 `Navigator.push` 跳转到对应的演示页。每张卡片同时展示「小节标题 + 关键技术关键词」，便于快速定位学习内容。

> 学习时既可以从首页统一进入，也可以在 VS Code 中直接打开 `chapter11/xxx.dart` 文件并按 `F5` 单独运行（每个小节文件都附带独立的 `main()` 入口）。

---

## 11.1 文件操作

> 📖 原文链接：[11.1 文件操作](https://book.flutterchina.club/chapter11/file_operation.html)

### 功能介绍

| 知识点 | 说明 |
| --- | --- |
| `path_provider` | 获取应用沙盒目录（文档目录、临时目录、外部存储） |
| `dart:io` File | 文件读写：`readAsString()` / `writeAsString()` |
| `getApplicationDocumentsDirectory()` | 获取只有本应用可访问的持久化目录 |
| 计数器持久化 | 点击次数写入 `counter.txt`，重启后可恢复 |

### 演示截图

| 代码 | 运行效果 |
| --- | --- |
| ![11.1 代码](assets/演示截图/11.1%20文件操作-代码.png) | ![11.1 运行](assets/演示截图/11.1%20文件操作-运行效果.png) |

### 核心代码示例

**获取文件路径 & 读取内容：**

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

**写入文件（持久化计数）：**

```dart
Future<void> _incrementCounter() async {
  setState(() { _counter++; });
  await (await _getLocalFile()).writeAsString('$_counter');
}
```

### 独立运行

```bash
# 在 VS Code 中打开 lib/chapter11/file_operation.dart，按 F5 即可
# 或命令行指定入口：
flutter run -t lib/chapter11/file_operation.dart
```
