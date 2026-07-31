import 'dart:io';

void main() {
  final Directory libDir = Directory('c:/dev/zetra/lib');
  if (!libDir.existsSync()) {
    print('Directory does not exist: ${libDir.path}');
    return;
  }
  for (final FileSystemEntity entity in libDir.listSync(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final String original = entity.readAsStringSync();
      String updated = original.replaceAll('.withOpacity(', '.withValues(alpha: ');
      updated = updated.replaceAll('.withValues(opacity:', '.withValues(alpha:');
      if (original != updated) {
        entity.writeAsStringSync(updated);
        print('Updated: ${entity.path}');
      }
    }
  }
  print('Replacement complete.');
}
