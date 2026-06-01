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

> 📌 后续每完成一个小节的验证（截图 + 文档），会在分隔线下方按统一格式增补：
>
> - 原文链接
> - 功能介绍（表格）
> - 代码截图 / 运行效果截图（双图对比）
> - 核心代码示例（可直接复制）
> - 独立运行命令
