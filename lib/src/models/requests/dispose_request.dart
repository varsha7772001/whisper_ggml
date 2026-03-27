import 'dart:convert';
import 'package:whisper_ggml/src/models/whisper_dto.dart';

/// Request to dispose whisper model
class DisposeRequest implements WhisperRequestDto {
  ///
  const DisposeRequest({required this.model});

  /// model path
  final String model;

  @override
  String get specialType => 'dispose';

  @override
  String toRequestString() =>
      json.encode({'@type': specialType, 'model': model});
}
