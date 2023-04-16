import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import '../../types.dart';

part 'picture_group.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  createToJson: false,
)
class PictureGroupsDto {
  const PictureGroupsDto({
    required this.groups,
  });

  final List<List<String>> groups;

  factory PictureGroupsDto.fromJson(Json json) =>
      _$PictureGroupsDtoFromJson(json);
}

FutureOr<PictureGroupsDto> deserializePictureGroupsDto(Json json) =>
    PictureGroupsDto.fromJson(json);