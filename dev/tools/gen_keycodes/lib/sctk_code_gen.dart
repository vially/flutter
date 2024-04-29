// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:path/path.dart' as path;

import 'base_code_gen.dart';
import 'logical_key_data.dart';
import 'physical_key_data.dart';
import 'utils.dart';


/// Generates the key mapping for SCTK, based on the information in the key
/// data structure given to it.
class SctkCodeGenerator extends PlatformCodeGenerator {
  SctkCodeGenerator(
    super.keyData,
    super.logicalData,
  );

  /// This generates the map of XKB scan codes to Flutter physical keys.
  String get _xkbScanCodeMap {
    final OutputLines<int> lines = OutputLines<int>('SCTK scancode map');
    for (final PhysicalKeyEntry entry in keyData.entries) {
      if (entry.xKbScanCode != null) {
        lines.add(entry.xKbScanCode!,
          '            ${toHex(entry.xKbScanCode)} => ${toHex(entry.usbHidCode)}, // ${entry.constantName}');
      }
    }
    return lines.sortedJoin().trimRight();
  }

  /// This generates the map of GTK keyval codes to Flutter logical keys.
  String get _sctkKeyvalCodeMap {
    final OutputLines<int> lines = OutputLines<int>('SCTK keyval map');
    for (final LogicalKeyEntry entry in logicalData.entries) {
      zipStrict(entry.gtkValues, entry.gtkNames, (int value, String name) {
        final String sctkName = name.startsWith('3270_') ? '_$name' : value >= 269025026 ? 'XF86_$name' : name;
        lines.add(value,
          '            Keysym::$sctkName => ${toHex(entry.value, digits: 11)},');
      });
    }
    return lines.sortedJoin().trimRight();
  }

  @override
  String get templatePath => path.join(dataRoot, 'sctk_key_mapping_rs.tmpl');

  @override
  String outputPath(String platform) => path.join(PlatformCodeGenerator.engineRoot,
      '..', '..', '..', 'flutter-rs', 'flutter-sctk', 'src', 'key_mapping_gen.rs');

  @override
  Map<String, String> mappings() {
    return <String, String>{
      'XKB_SCAN_CODE_MAP': _xkbScanCodeMap,
      'SCTK_KEYVAL_CODE_MAP': _sctkKeyvalCodeMap,
    };
  }
}
