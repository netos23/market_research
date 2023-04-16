import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import '../../types.dart';

part 'predict_picture.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  createFactory: false
)
class PredictPictureDto {
  const PredictPictureDto({
    required this.base64,
  });

  final String base64;

  Json toJson() => _$PredictPictureDtoToJson(this);
}
