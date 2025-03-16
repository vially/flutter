// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../base/file_system.dart';
import '../build_info.dart';
import '../build_system/build_system.dart';
import '../build_system/build_targets.dart';
import '../build_system/targets/common.dart';
import '../build_system/targets/dart_plugin_registrant.dart';
import '../build_system/targets/localizations.dart';
import '../build_system/targets/web.dart';
import '../web/compiler_config.dart';

class BuildTargetsImpl extends BuildTargets {
  const BuildTargetsImpl();

  @override
  Target get generateLocalizationsTarget => const GenerateLocalizationsTarget();

  @override
  Target get dartPluginRegistrantTarget => const DartPluginRegistrantTarget();

  @override
  Target webServiceWorker(FileSystem fileSystem, List<WebCompilerConfig> compileConfigs) =>
      WebServiceWorker(fileSystem, compileConfigs);

  @override
  Target buildFlutterBundle({
    required BuildMode mode,
    @Deprecated(
      'Use the build environment `outputDir` instead. '
      'This feature was deprecated after v3.31.0-1.0.pre.',
    )
    Directory? assetDir,
  }) {
    return mode == BuildMode.debug
        ? CopyFlutterBundle(assetDir: assetDir)
        : ReleaseCopyFlutterBundle(assetDir: assetDir);
  }
}
