import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/http.dart';
import 'package:web_page/data/models/picture_group.dart';
import 'package:web_page/data/models/picture_list.dart';
import 'package:web_page/data/models/predict_picture.dart';

part 'picture_service.g.dart';

@RestApi()
abstract class PictureService {
  factory PictureService(Dio dio, {String baseUrl}) = _PictureService;

  @GET("/pictures")
  Future<PictureListDto> getPictures();

  @GET("/pictures/groups")
  Future<PictureGroupsDto> getPictureGroups();

  @POST("/pictures/predict")
  Future<PictureListDto> postPredictPicture({
    @Body() required PredictPictureDto pictureDto,
  });
}
