import 'dart:io';

void main() async {
  final dir = Directory('c:/dev/zetra/lib');
  await for (var entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final newContent = content.replaceAllMapped(RegExp(r'\.withOpacity\('), (match) => '.withValues(opacity: ');
      if (newContent != content) {
        await entity.writeAsString(newContent);
        print('Updated ${entity.path}');
      }
    }
  }
}
