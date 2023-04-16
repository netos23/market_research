import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import '../../types.dart';

part 'picture_list.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  createToJson: false,
)
class PictureListDto {
  const PictureListDto({
    required this.pictures,
  });

  final List<String> pictures;

  factory PictureListDto.fromJson(Json json) =>
      _$PictureListDtoFromJson(json);
}

FutureOr<PictureListDto> deserializePictureListDto(Json json) =>
    PictureListDto.fromJson(json);