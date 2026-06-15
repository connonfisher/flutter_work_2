// 来源：https://dart.ac.cn/tutorials/server/httpserver
// 功能：简单 Dart HTTP 服务器 —— 使用 shelf 包搭建 HTTP 服务、
//       演示路由处理、中间件（日志）、请求响应
// 运行：dart run lib/tutorials/04_server.dart
//       然后访问 http://localhost:8080

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// 主入口：启动 HTTP 服务器
void main() async {
  // 创建路由器
  final app = Router();

  // 注册路由
  app.get('/', _handleRoot);
  app.get('/hello/<name>', _handleHello);
  app.get('/echo', _handleEcho);

  // 添加日志中间件
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app.call);

  // 启动服务器
  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('========================================');
  print('  Dart HTTP 服务器已启动');
  print('  地址：http://localhost:${server.port}');
  print('========================================');
  print('  可用端点：');
  print('    GET /                 首页');
  print('    GET /hello/<name>    个性化问候');
  print('    GET /echo             回显请求');
  print('========================================');
}

/// 处理根路径请求
Response _handleRoot(Request request) {
  return Response.ok(
    '''
╔══════════════════════════════════════╗
║   Welcome to Dart HTTP Server!      ║
║                                      ║
║  可用端点:                           ║
║   GET /hello/<name>  - 问候          ║
║   GET /echo          - 回显信息      ║
╚══════════════════════════════════════╝
''',
    headers: {'Content-Type': 'text/plain; charset=utf-8'},
  );
}

/// 处理 /hello/<name> 请求
Response _handleHello(Request request, String name) {
  return Response.ok(
    'Hello, $name! 欢迎来到 Dart Shelf HTTP 服务器 🎉\n',
    headers: {'Content-Type': 'text/plain; charset=utf-8'},
  );
}

/// 处理 /echo 请求
Response _handleEcho(Request request) {
  final info = '''
请求方法：${request.method}
请求 URL：${request.url}
请求头：
${request.headers.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}
''';
  return Response.ok(
    '请求回显：\n$info',
    headers: {'Content-Type': 'text/plain; charset=utf-8'},
  );
}
