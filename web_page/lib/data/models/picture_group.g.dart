// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureGroupsDto _$PictureGroupsDtoFromJson(Map<String, dynamic> json) =>
    PictureGroupsDto(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );
