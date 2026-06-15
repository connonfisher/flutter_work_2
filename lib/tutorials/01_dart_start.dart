// 来源：https://dart.ac.cn/tutorials/server/get-started
// 功能：Dart 基础入门 —— 演示 `dart create -t console` 模板项目结构、
//       calculate 函数、dart run 运行方式、dart compile exe AOT 编译
// 运行：dart run lib/tutorials/01_dart_start.dart

/// 计算 6 * 7 的结果
int calculate() {
  return 6 * 7;
}

void main() {
  print('Hello world: ${calculate()}!');

  // ---- 额外演示：修改后的版本（教程第5步） ----
  print('修改后 (6 * 7 ~/ 2): ${calculateModified()}');
}

/// 修改版：除以二（使用 ~/ 整除运算符）
int calculateModified() {
  return 6 * 7 ~/ 2;
}
