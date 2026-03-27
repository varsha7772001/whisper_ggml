import 'dart:convert';
import 'package:whisper_ggml/src/models/whisper_dto.dart';

/// Request to initialize whisper model
class InitRequest implements WhisperRequestDto {
  ///
  const InitRequest({required this.model});

  /// model path
  final String model;

  @override
  String get specialType => 'init';

  @override
  String toRequestString() =>
      json.encode({'@type': specialType, 'model': model});
}
