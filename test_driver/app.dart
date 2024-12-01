import 'package:demo/drag_commands.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:demo/main.dart' as app;

void main() {
  enableFlutterDriverExtension(
      commands: [DragCommandExtension()]);
  app.main();
}
