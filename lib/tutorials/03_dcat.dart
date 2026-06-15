// 来源：https://dart.ac.cn/tutorials/server/cmdline
// 功能：命令行应用 dcat 示例 —— 完整演示命令行参数解析（args 包）、
//       stdin/stdout/stderr 读写、文件信息获取、文件读写、环境信息、退出码
// 运行：
//   dart run lib/tutorials/03_dcat.dart -- -n lib/tutorials/03_dcat.dart
//   dart run lib/tutorials/03_dcat.dart -- lib/tutorials/00_helloworld.dart
//   echo "hello from stdin" | dart run lib/tutorials/03_dcat.dart

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

void main(List<String> arguments) {
  exitCode = 0; // 预设成功
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, showLineNumbers: argResults[lineNumber] as bool);
}

/// 核心函数：显示文件内容，若无参数则从 stdin 读取
Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
  if (paths.isEmpty) {
    // 无文件参数：从 stdin 读取并逐行输出到 stdout
    await stdin.pipe(stdout);
  } else {
    for (final path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      try {
        await for (final line in lines) {
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

/// 错误处理：判断路径是否是目录
Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}

// ==============================
// 额外演示函数：文件读写 & 环境信息 & 退出码
// ==============================

/// 演示：写入文件
Future<void> demoWriteFile() async {
  final quotes = File('quotes.txt');
  const stronger = 'That which does not kill us makes us stronger. -Nietzsche';
  await quotes.writeAsString(stronger, mode: FileMode.append);
  print('已写入 quotes.txt');
}

/// 演示：使用 openWrite 追加写入
Future<void> demoOpenWrite() async {
  final quotes = File('quotes.txt').openWrite(mode: FileMode.append);
  quotes.write("Don't cry because it's over, ");
  quotes.writeln('smile because it happened. -Dr. Seuss');
  await quotes.close();
  print('已追加写入 quotes.txt');
}

/// 演示：读取 stdin 单行
void demoReadStdin() {
  stdout.writeln('请输入一些文字：');
  final input = stdin.readLineSync();
  stdout.writeln('你输入了: $input');
}

/// 演示：获取环境信息
void demoEnvironment() {
  final envVarMap = Platform.environment;
  print('操作系统：${Platform.operatingSystem}');
  print('处理器数量：${Platform.numberOfProcessors}');
  print('脚本路径：${Platform.script}');
  print('PATH = ${envVarMap['PATH']}');
}
