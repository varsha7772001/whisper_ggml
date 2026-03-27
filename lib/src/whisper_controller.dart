import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:whisper_ggml/src/models/whisper_model.dart';

import 'models/whisper_result.dart';
import 'whisper.dart';

class WhisperController {
  String _modelPath = '';
  String? _dir;

  bool _isInitialized = false;
  late Whisper _whisper;

  Future<void> initModel(WhisperModel model) async {
    _dir ??= await getModelDir();
    _modelPath = '$_dir/ggml-${model.modelName}.bin';
    _whisper = Whisper(model: model);
    if (!_isInitialized) {
      await _whisper.init(_modelPath);
      _isInitialized = true;
    }
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _whisper.dispose(_modelPath);
      _isInitialized = false;
    }
  }

  Future<TranscribeResult?> transcribe({
    required WhisperModel model,
    required String audioPath,
    String lang = 'en',
    bool diarize = false,
  }) async {
    await initModel(model);

    final DateTime start = DateTime.now();
    const bool translate = false;
    const bool withSegments = false;
    const bool splitWords = false;

    try {
      final WhisperTranscribeResponse transcription =
          await _whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: audioPath,
          language: lang,
          isTranslate: translate,
          isNoTimestamps: !withSegments,
          splitOnWord: splitWords,
          isRealtime: true,
          diarize: diarize,
        ),
        modelPath: _modelPath,
      );

      final Duration transcriptionDuration = DateTime.now().difference(start);

      return TranscribeResult(
        time: transcriptionDuration,
        transcription: transcription,
      );
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<String> getModelDir() async {
    final Directory libraryDirectory = Platform.isAndroid
        ? await getApplicationSupportDirectory()
        : await getLibraryDirectory();
    return libraryDirectory.path;
  }

  /// Get local path of model file
  Future<String> getPath(WhisperModel model) async {
    _dir ??= await getModelDir();
    return '$_dir/ggml-${model.modelName}.bin';
  }

  /// Download [model] to [destinationPath]
  Future<String> downloadModel(WhisperModel model) async {
    if (!File(await getPath(model)).existsSync()) {
      final request = await HttpClient().getUrl(model.modelUri);

      final response = await request.close();

      final bytes = await consolidateHttpClientResponseBytes(response);

      final File file = File(await getPath(model));
      await file.writeAsBytes(bytes);

      return file.path;
    } else {
      return await getPath(model);
    }
  }
}
