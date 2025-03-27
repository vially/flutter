// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../base/file_system.dart';
import '../build_info.dart';
import '../web/compiler_config.dart';
import './build_system.dart';

/// Commonly used build [Target]s.
abstract class BuildTargets {
  const BuildTargets();

  Target get generateLocalizationsTarget;
  Target get dartPluginRegistrantTarget;
  Target webServiceWorker(FileSystem fileSystem, List<WebCompilerConfig> compileConfigs);
  Target buildFlutterBundle({
    required TargetPlatform platform,
    required BuildMode mode,
    bool buildAOTAssets = true,
    @Deprecated(
      'Use the build environment `outputDir` instead. '
      'This feature was deprecated after v3.31.0-1.0.pre.',
    )
    Directory? assetDir,
  });
}

/// BuildTargets that return NoOpTarget for every action.
class NoOpBuildTargets extends BuildTargets {
  const NoOpBuildTargets();

  @override
  Target get generateLocalizationsTarget => const _NoOpTarget();

  @override
  Target get dartPluginRegistrantTarget => const _NoOpTarget();

  @override
  Target webServiceWorker(FileSystem fileSystem, List<WebCompilerConfig> compileConfigs) =>
      const _NoOpTarget();

  @override
  Target buildFlutterBundle({
    required TargetPlatform platform,
    required BuildMode mode,
    bool buildAOTAssets = true,
    @Deprecated(
      'Use the build environment `outputDir` instead. '
      'This feature was deprecated after v3.31.0-1.0.pre.',
    )
    Directory? assetDir,
  }) => const _NoOpTarget();
}

/// A [Target] that does nothing.
class _NoOpTarget extends Target {
  const _NoOpTarget();

  @override
  String get name => 'no_op';

  @override
  List<Source> get inputs => const <Source>[];

  @override
  List<Source> get outputs => const <Source>[];

  @override
  List<Target> get dependencies => const <Target>[];

  @override
  Future<void> build(Environment environment) async {}
}
