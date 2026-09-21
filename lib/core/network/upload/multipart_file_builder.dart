import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_base_project/core/logging/app_logger.dart';

class MultipartFileBuilder {
  const MultipartFileBuilder._();

  static Future<List<MultipartFile>> buildMultipartFiles(
    List<String> paths, {
    String? apiName,
  }) async {
    if (apiName != null) {
      await _logUploadFiles(apiName, paths);
    }

    return paths
        .map((path) {
          final file = File(path);
          if (!file.existsSync()) {
            throw FileSystemException('Upload file does not exist', path);
          }

          if (file.lengthSync() <= 0) {
            throw FileSystemException('Upload file is empty', path);
          }

          return MultipartFile.fromFileSync(path);
        })
        .toList(growable: false);
  }

  static Future<MultipartFile> buildMultipartFile(
    String path, {
    String? apiName,
  }) async {
    final files = await buildMultipartFiles([path], apiName: apiName);
    return files.first;
  }

  static Future<void> _logUploadFiles(
    String apiName,
    List<String> paths,
  ) async {
    final files = paths
        .map((path) {
          final file = File(path);
          final exists = file.existsSync();
          int? sizeInBytes;

          if (exists) {
            try {
              sizeInBytes = file.lengthSync();
            } catch (_) {
              sizeInBytes = null;
            }
          }

          return {'path': path, 'exists': exists, 'sizeInBytes': sizeInBytes};
        })
        .toList(growable: false);

    try {
      await AppLogger().log(
        '[$apiName] upload files',
        level: LogLevel.info,
        detail: {'fileCount': paths.length, 'files': files},
      );
    } catch (_) {
      // Logging should not break upload flow
    }
  }
}
