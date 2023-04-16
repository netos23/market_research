import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:web_page/types.dart';

import 'data/picture_service.dart';
import 'screens/main/main_screen.dart';
import 'screens/predict_form/predict_form_screen.dart';
import 'screens/preview_screen/preview_screen.dart';
import 'screens/result_screen/result_screen.dart';

class PictureApp extends StatelessWidget {
  const PictureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(
          create: (_) => Dio()
            ..options.baseUrl = baseUrl
            ..options.connectTimeout = const Duration(seconds: 15)
            ..options.receiveTimeout = const Duration(seconds: 15)
            ..interceptors.add(
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                responseBody: true,
                responseHeader: false,
                error: true,
                compact: true,
                maxWidth: 90,
              ),
            ),
        ),
        Provider<PictureService>(
          create: (ctx) => PictureService(
            ctx.read(),
          ),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const MainScreen(),
              );
            case '/search':
              return MaterialPageRoute(
                builder: (_) => const PredictFormScreen(),
              );
            case '/preview':
              return MaterialPageRoute(
                builder: (_) => PreviewScreen(
                  bytes: settings.arguments as Uint8List,
                ),
              );
            case '/result':
              return MaterialPageRoute(
                builder: (context) => ResultScreen(
                  bytes: settings.arguments as Uint8List,
                  service: context.read(),
                ),
              );
          }
        },
      ),
    );
  }
}
