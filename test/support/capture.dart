import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Menyimpan tangkapan widget. Lewat saja bila folder artefak tidak bisa dibuat,
/// supaya tes tetap jalan di mesin yang tidak punya folder itu.
Future<void> captureFinder(
  WidgetTester tester,
  Finder finder,
  String name,
) async {
  final directory = Directory('/opt/cursor/artifacts');
  final exists = await tester.runAsync(() async {
    try {
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  });
  if (exists != true) {
    return;
  }

  await tester.pump();
  final boundary = tester.renderObject<RenderRepaintBoundary>(finder);
  // toImage async menunggu raster dan mengunci binding tes.
  final image = boundary.toImageSync(pixelRatio: 2);
  await tester.runAsync(() async {
    final raw = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (raw == null) {
      return;
    }
    final data = Uint8List.fromList(
      raw.buffer.asUint8List(raw.offsetInBytes, raw.lengthInBytes),
    );
    await File('${directory.path}/$name.png').writeAsBytes(data, flush: true);
  });
}
