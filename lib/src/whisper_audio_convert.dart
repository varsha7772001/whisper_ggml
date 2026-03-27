import 'dart:async';

import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_new_min/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

/// Class used to convert any audio file to wav
class WhisperAudioConvert {
  ///
  const WhisperAudioConvert({
    required this.audioInput,
    required this.audioOutput,
  });

  /// Input audio file
  final File audioInput;

  /// Output audio file
  /// Overwriten if already exist
  final File audioOutput;

  /// convert [audioInput] to wav file
  Future<File?> convert() async {
    // Check if input is already a compatible WAV to avoid redundant conversion
    if (audioInput.path.endsWith('.wav')) {
      // For simplicity, we trust the extension here, 
      // but in a more robust implementation we might check the header.
      // If it exists and is .wav, we can try to skip.
      // However, Whisper specifically needs 16kHz mono PCM.
      // So it's safer to run FFmpeg unless we are SURE.
      // A compromise: if the output file already exists and is the same as input, return it.
      if (audioInput.path == audioOutput.path) {
        return audioInput;
      }
    }

    final FFmpegSession session = await FFmpegKit.execute(
      [
        '-y',
        '-i',
        audioInput.path,
        '-ar',
        '16000',
        '-ac',
        '1',
        '-c:a',
        'pcm_s16le',
        audioOutput.path,
      ].join(' '),
    );

    final ReturnCode? returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return audioOutput;
    } else if (ReturnCode.isCancel(returnCode)) {
      debugPrint('File convertion canceled');
    } else {
      debugPrint(
        'File convertion error with returnCode ${returnCode?.getValue()}',
      );
    }

    return null;
  }
}
