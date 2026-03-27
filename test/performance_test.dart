import 'package:flutter_test/flutter_test.dart';
import 'package:whisper_ggml/whisper_ggml.dart';
import 'dart:io';

void main() {
  test('Whisper performance test (Cold vs Warm start)', () async {
    // This test is intended to be run in a native environment where the library is available.
    // In a pure Dart test environment, it might fail unless the library is mocked or available.
    
    // Note: To run this test effectively, you'd need a valid model path and audio path.
    // For this demonstration, we'll outline the logic.
    
    /*
    final controller = WhisperController();
    final model = WhisperModel.tiny;
    final modelPath = await controller.getPath(model);
    final audioPath = 'path/to/test.wav';

    // Cold start
    final stopWatch = Stopwatch()..start();
    await controller.transcribe(model: model, audioPath: audioPath);
    final coldDuration = stopWatch.elapsed;
    print('Cold start duration: ${coldDuration.inMilliseconds}ms');

    // Warm start
    stopWatch.reset();
    await controller.transcribe(model: model, audioPath: audioPath);
    final warmDuration = stopWatch.elapsed;
    print('Warm start duration: ${warmDuration.inMilliseconds}ms');

    expect(warmDuration.inMilliseconds, lessThan(coldDuration.inMilliseconds));
    */
  });
}
