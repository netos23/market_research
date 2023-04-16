import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_page/data/models/picture_list.dart';
import 'package:web_page/data/models/predict_picture.dart';
import 'package:web_page/data/picture_service.dart';
import 'package:web_page/types.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    Key? key,
    required this.bytes,
    required this.service,
  }) : super(key: key);

  final Uint8List bytes;
  final PictureService service;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Похожие изображения'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Image.memory(widget.bytes),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Похожие изображения',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          FutureBuilder(
            future: _getSimular(),
            builder: (context, snap) {
              final data = snap.data?.pictures;

              if (snap.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Возникла ошибка.',
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text(
                            'Повторить',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (data == null) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Image.network('$baseAssetsUrl/${data[index]}');
                }, childCount: data.length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<PictureListDto> _getSimular() async {
    final base64 = base64Encode(widget.bytes);
    return await widget.service.postPredictPicture(
      pictureDto: PredictPictureDto(
        base64: base64,
      ),
    );
  }
}
