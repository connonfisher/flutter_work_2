// 来源：https://dart.ac.cn/tutorials/server/httpserver
// 功能：简单 Dart HTTP 服务器 —— 使用 dart:io HttpServer 搭建 HTTP 服务、
//       演示路由分发、请求解析、响应构造
// 运行：dart run lib/tutorials/04_server.dart
//       然后访问 http://localhost:8080

import 'dart:io';

/// 主入口：启动 HTTP 服务器
void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('========================================');
  print('  Dart HTTP 服务器已启动');
  print('  地址：http://localhost:${server.port}');
  print('========================================');
  print('  可用端点：');
  print('    GET /                 首页');
  print('    GET /hello/<name>    个性化问候');
  print('    GET /echo             回显信息');
  print('========================================');

  await for (final request in server) {
    _handleRequest(request);
  }
}

/// 请求路由分发
void _handleRequest(HttpRequest request) {
  final path = request.uri.path;

  if (path == '/') {
    _respond(request, 200, _rootPage());
  } else if (path.startsWith('/hello/')) {
    final name = path.substring('/hello/'.length);
    _respond(request, 200, 'Hello, $name! 欢迎来到 Dart HTTP 服务器\n');
  } else if (path == '/echo') {
    _respond(request, 200, '''
请求回显：
请求方法：${request.method}
请求 URL：${request.uri}
请求头：
${_formatHeaders(request.headers)}
''');
  } else {
    _respond(request, 404, '404 Not Found\n');
  }
}

/// 构造响应
void _respond(HttpRequest request, int statusCode, String body) {
  request.response
    ..statusCode = statusCode
    ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
    ..write(body);
  request.response.close();
}

/// 首页内容
String _rootPage() {
  return '''
╔══════════════════════════════════════╗
║   Welcome to Dart HTTP Server!      ║
║                                      ║
║  可用端点:                           ║
║   GET /hello/<name>  - 问候          ║
║   GET /echo          - 回显信息      ║
╚══════════════════════════════════════╝
''';
}

/// 格式化请求头
String _formatHeaders(HttpHeaders headers) {
  final lines = <String>[];
  headers.forEach((name, values) {
    lines.add('  $name: ${values.join(', ')}');
  });
  return lines.join('\n');
}
