import 'dart:io';

void main() {
  final libDir = Directory('c:/dev/zetra/lib');
  if (!libDir.existsSync()) {
    print('Directory does not exist: ${libDir.path}');
    return;
  }
  for (final entity in libDir.listSync(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final original = entity.readAsStringSync();
      var updated = original.replaceAll('.withOpacity(', '.withValues(alpha: ');
      updated = updated.replaceAll('.withValues(opacity:', '.withValues(alpha:');
      if (original != updated) {
        entity.writeAsStringSync(updated);
        print('Updated: ${entity.path}');
      }
    }
  }
  print('Replacement complete.');
}
