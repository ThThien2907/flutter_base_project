import 'dart:developer' as developer;
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum LogLevel { info, warning, error }

enum ShareLogResult { success, notFound, failure }

class AppLogger {
  static final AppLogger _instance = AppLogger._();
  factory AppLogger() => _instance;
  AppLogger._();

  static bool enabled = true;

  Future<void> _writeQueue = Future.value();

  static void configure({required bool enabled}) {
    AppLogger.enabled = enabled;
  }

  String _logFileNameByDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return 'app_log_$y-$m-$d.txt';
  }

  Future<File?> _getTodayLogFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = _logFileNameByDate(DateTime.now());
      return File('${dir.path}/$fileName');
    } catch (_) {
      return null;
    }
  }

  Future<void> log(
    String msg, {
    LogLevel level = LogLevel.info,
    dynamic detail,
  }) async {
    if (!enabled) return;

    try {
      final time = DateTime.now().toIso8601String();
      final lv = level.name.toUpperCase();
      final logText =
          '[$time][$lv] $msg${detail != null ? " : ${detail.toString()}" : ""}';

      developer.log(logText, name: 'AppLogger');

      final file = await _getTodayLogFile();
      if (file != null) {
        _writeQueue = _writeQueue.then((_) async {
          try {
            await file.writeAsString('$logText\n', mode: FileMode.append);
          } catch (_) {
            // File logging failure should never crash the app
          }
        });
        await _writeQueue;
      }
    } catch (_) {
      // Safe fallback
    }
  }

  Future<ShareLogResult> shareTodayLog() async {
    if (!enabled) return ShareLogResult.notFound;
    return shareLogByDate(DateTime.now());
  }

  Future<ShareLogResult> shareLogByDate(DateTime date) async {
    if (!enabled) return ShareLogResult.notFound;

    try {
      await _writeQueue;

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/${_logFileNameByDate(date)}');

      if (!await file.exists()) return ShareLogResult.notFound;

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'App Log $formattedDate',
        ),
      );
      return ShareLogResult.success;
    } catch (e) {
      developer.log('Share log failed', error: e, name: 'AppLogger');
      return ShareLogResult.failure;
    }
  }

  Future<void> shareAllLogs() async {
    if (!enabled) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('app_log_'))
          .map((f) => XFile(f.path))
          .toList();

      if (files.isEmpty) return;

      await SharePlus.instance.share(
        ShareParams(files: files, subject: 'All App Logs'),
      );
    } catch (e) {
      developer.log('Share all logs failed', error: e, name: 'AppLogger');
    }
  }

  Future<void> cleanOldLogs({int keepDays = 7}) async {
    if (!enabled) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final now = DateTime.now();

      for (final e in dir.listSync()) {
        if (e is! File) continue;
        if (!e.path.contains('app_log_')) continue;

        final dateStr =
            RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(e.path)?.group(0);

        if (dateStr == null) continue;

        final date = DateTime.tryParse(dateStr);
        if (date != null && now.difference(date).inDays > keepDays) {
          await e.delete();
        }
      }
    } catch (_) {
      // Safe fallback
    }
  }
}
