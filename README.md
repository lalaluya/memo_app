# 拾光 · 烛烬笔记 (Shíguāng Memo)

> 一款仿 iOS 视觉的纯本地离线备忘录 App，由 Flutter 跨平台实现。

![banner](assets/fonts/.gitkeep)

## 简介

把文字当作烛火，写下它，让它在时间里安静燃烧。
在这里，没有点赞、没有算法，只有你和那些还没走远的瞬间。

本项目源自 ` `memo-app-v2/index.html` `（React 单文件原型），在保持所有视觉与交互细节不变的前提下，使用 **Flutter** 全量重写为跨平台移动应用，并补齐了原型的数据持久化、导出、加锁、真黑模式等增强功能。

## 效果预览

启动后呈现一个仿 iOS 的设备框：

- 状态栏（时间 + 信号格 + 5G + 电池）
- Dynamic Island 黑色胶囊
- 标题 `拾光` + 当日日期（`X月X日 · 时段 · 拾光`）
- 搜索框、标签 chip 行（`日常 / 随想 / 摘录 / 待办`）
- 5 条种子笔记按 stagger 渐入
- 右下角朱砂 FAB（带阴影、按下 scale 反馈）
- 底部毛玻璃 Tab Bar（`笔记 / 标签 / 我的`）
- Home Indicator

页面切换带 `slideInRight / slideInLeft` 320ms 过渡，主题切换 280ms 平滑过渡。

## 功能

### 核心
- **列表**：stagger 渐入笔记列表，按标签过滤
- **详情**：标题 / 正文 / 字号设置生效 / 一键删除
- **编辑**：新建 / 编辑共用，标签多选
- **搜索**：实时高亮，结果数，诗句空状态
- **标签**：所有标签 + 数量，按标签筛选
- **我的**：头像 / 统计 / 设置入口
- **设置**：深色模式、OLED 真黑、字号、启动加锁、生物识别、修改 PIN、导出全部
- **关于**：Logo / 版本 / 设计理念 / 致谢

### 增强
- **SQLite 本地持久化**（首次启动自动 seed 5 条与原型相同文案）
- **删除 + 撤销**（4 秒 Toast 窗口）
- **深色模式持久化**
- **OLED 真黑模式**
- **字号三档**（`细 14 / 常 16 / 粗 18`）
- **PIN 加锁**（4 位数字，`flutter_secure_storage` 加密存储）
- **生物识别解锁**（`local_auth`）
- **导出全部笔记**（JSON + `share_plus` 系统分享）
- **Noto Serif SC / Noto Sans SC 中文字体**（`google_fonts` 运行时下载）

## 技术栈

| 维度 | 选型 |
| --- | --- |
| 框架 | Flutter 3.24+ |
| 状态管理 | `flutter_riverpod` |
| 持久化 | `sqflite` + `path_provider` |
| 导航 | 自定义 `slideRoute`（`PageRouteBuilder`） |
| 样式 | 纯自绘（`Container / Stack / AnimatedContainer`），不用 `Scaffold`/`AppBar` 默认组件 |
| 字体 | `google_fonts`（Noto Serif SC + Noto Sans SC） |
| 增强 | `local_auth` / `share_plus` / `flutter_secure_storage` |
| 目标平台 | Android 7.0+ / iOS 13.0+ / Web |

## 项目结构

```
memo_app/
├── pubspec.yaml
├── android/              # Android 工程
├── ios/                  # iOS 工程
├── web/                  # Web 工程
├── lib/
│   ├── main.dart         # 入口
│   ├── app.dart          # MaterialApp + 主题切换
│   ├── theme/
│   │   ├── app_theme.dart            # Light / Dark ColorScheme
│   │   └── ...
│   ├── router/
│   │   └── app_router.dart           # 自定义 slideRoute
│   ├── data/
│   │   ├── models/{memo,app_settings}.dart
│   │   ├── db/memo_database.dart     # sqflite 建表 + seed
│   │   └── repositories/
│   ├── providers/{memo,settings,toast}_provider.dart
│   ├── screens/
│   │   ├── shell/phone_shell.dart    # 仿 iOS 设备框
│   │   ├── list/                     # 列表页 + FAB / search_box / tag_chip_row
│   │   ├── detail/memo_detail_screen.dart
│   │   ├── edit/memo_edit_screen.dart
│   │   ├── search/search_screen.dart
│   │   ├── tags/{tags_cloud,tag_filter}_screen.dart
│   │   ├── my/my_screen.dart
│   │   ├── settings/settings_screen.dart
│   │   ├── about/about_screen.dart
│   │   ├── empty/empty_screen.dart
│   │   └── lock/lock_screen.dart
│   ├── widgets/                       # status_bar / dynamic_island / home_indicator / tab_bar / toast / confirm_dialog / header
│   └── utils/highlight_text.dart
└── assets/fonts/
```

## 快速开始

### 环境要求
- Flutter 3.24+ stable
- Dart 3.5+
- Android：Android SDK 34+ / JDK 17
- iOS：Xcode 15+（仅 macOS）
- Web：Chrome / Edge

### 安装与运行

```bash
# 拉依赖
flutter pub get

# 模拟器 / 真机
flutter devices
flutter run -d chrome              # 浏览器
flutter run -d <android-device>    # Android
flutter run -d <ios-device>        # iOS（需 macOS）
```

### 构建发布包

```bash
flutter build apk --release        # Android APK
flutter build ios --release --no-codesign  # iOS（需 macOS）
flutter build web --release        # 静态资源
```

## 设计参考

源自 `memo-app-v2/index.html` 原型：

- **主题色**：朱砂 `#C04A1A` / 暖橙 `#D86A38`
- **背景**：暖白 `#FAF8F4` / 暗夜 `#1A1815` / OLED `#000000`
- **字体**：Noto Serif SC（标题）+ Noto Sans SC（正文）
- **设备外形**：iPhone 15 Pro（393×852，56 圆角外框）
- **动效曲线**：`cubic-bezier(0.32, 0.72, 0, 1)` ≈ `Curves.easeOutCubic`

## 致谢

- Noto Serif / Noto Sans 项目提供的中文字体
- Flutter 让这一切成为可能
- 每一个愿意慢下来写字的你

## License

MIT