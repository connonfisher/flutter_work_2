/// 演示 Dart 库与导入功能的示例库
library;

// 来源：https://dart.ac.cn/language/libraries
// 功能：Dart 库与导入 —— 演示 import、as 前缀、show/hide 选择性导入、
//       deferred as 延迟加载、library 指令
// 运行：dart run lib/tutorials/02_dart_library.dart

// ============================
// 1. 基础导入：内置库 dart: 方案
// ============================
import 'dart:math' show pi; // 只导入 pi
import 'dart:math' as math; // 带前缀导入，避免命名冲突

// ============================
// 2. 选择性导入：show 和 hide
// ============================
// show: 只导入指定的名称
// hide: 导入除指定名称外的全部
// import 'dart:math' hide sin; // 示例：导入 math 中除 sin 外的所有内容

/// 一个简单的 Point 类，用于演示库的使用
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);

  double distanceTo(Point other) {
    return math.sqrt(math.pow(other.x - x, 2) + math.pow(other.y - y, 2));
  }

  @override
  String toString() => 'Point($x, $y)';
}

// ============================
// 4. 主函数：综合演示
// ============================
void main() {
  print('===== Dart 库与导入功能演示 =====\n');

  // 4.1 使用 show 导入的 pi
  print('【show 导入】只导入了 pi');
  print('π = $pi\n');

  // 4.2 使用 as 前缀导入
  print('【as 前缀导入】通过 math. 前缀访问');
  print('e = ${math.e}');
  print('sin(π/2) = ${math.sin(math.pi / 2)}\n');

  // 4.3 使用自定义类
  print('【自定义类】Point 类的使用');
  const p1 = Point(0, 0);
  const p2 = Point(3, 4);
  print('$p1 到 $p2 的距离 = ${p1.distanceTo(p2)}\n');

  // 4.4 库延迟加载说明
  print('【延迟加载 deferred as】（仅 Web 平台支持）');
  print('语法: import \'package:xxx/xxx.dart\' deferred as xxx;');
  print('使用时调用: await xxx.loadLibrary();\n');

  print('===== 演示完成 =====');
}
