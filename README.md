# value_localization_core

一个用于 Dart/Flutter 应用的国际化 (i18n) 核心库，支持 JSON 格式的多语言翻译管理。

[![Pub Version](https://img.shields.io/pub/v/value_localization_core)](https://pub.dev/packages/value_localization_core)
[![GitHub](https://img.shields.io/github/stars/ValueNotify666/value_localization_core)](https://github.com/ValueNotify666/value_localization_core)

## 特性

- **JSON 格式翻译文件** - 简单易懂的翻译文件格式
- **异步加载** - 支持从网络或本地异步加载翻译文件
- **运行时语言切换** - 动态切换应用语言，无需重启
- **参数插值** - 支持 `Hello, {name}!` 格式的参数替换
- **翻译缓存** - 自动缓存已加载的翻译，提升性能
- **语言变更通知** - 通过 Stream 监听语言切换事件
- **Isolate 解码** - 支持在 Isolate 中解析 JSON，避免阻塞主线程

## 开始使用

### 添加依赖

```yaml
dependencies:
  value_localization_core: ^1.0.0
```

### 创建翻译文件

创建 `assets/lang/en.json`:
```json
{
  "hello": "Hello",
  "greeting": "Hello, {name}!"
}
```

创建 `assets/lang/zh.json`:
```json
{
  "hello": "你好",
  "greeting": "你好, {name}!"
}
```

## 用法

```dart
import 'package:value_localization_core/value_localization_core.dart';

// 创建本地化实例
final localization = ValueLocalizationCore(
  source: AssetLocalizationSource('assets/lang'), // 自定义 source
);

// 初始化并加载默认语言
await localization.init(langCode: 'en');

// 获取翻译
print(localization.get('hello')); // 输出: Hello

// 带参数的翻译
print(localization.get('greeting', params: {'name': 'World'})); // 输出: Hello, World!

// 切换语言
await localization.set('zh');
print(localization.get('hello')); // 输出: 你好

// 监听语言变更
localization.langCodeStream.listen((langCode) {
  print('语言已切换为: $langCode');
});
```

## 核心组件

| 组件 | 说明 |
|------|------|
| `ValueLocalizationCore` | 核心本地化类，管理翻译加载和切换 |
| `LocalizationSource` | 翻译数据源抽象，可实现网络/本地加载 |
| `LocalizationDecoder` | 翻译文件解码器，支持 JSON 解析 |
| `LangRegistry` | 语言注册表，管理语言代码与文件路径映射 |
| `LocalizationLogger` | 日志接口，用于调试和错误追踪 |

## 更多信息

- **源码**: https://github.com/ValueNotify666/value_localization_core
- **问题反馈**: 请在 GitHub Issues 提交问题
- **许可证**: MIT License
