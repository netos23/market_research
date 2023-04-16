import 'package:flutter/material.dart';
import 'package:web_page/data/models/picture_list.dart';
import 'package:web_page/types.dart';

class PictureListScreen extends StatefulWidget {
  const PictureListScreen({
    Key? key,
    required this.future,
  }) : super(key: key);
  final Future<PictureListDto> future;

  @override
  State<PictureListScreen> createState() => _PictureListScreenState();
}

class _PictureListScreenState extends State<PictureListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snap) {
        final data = snap.data?.pictures;


        if (snap.hasError) {
          return Center(
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
          );
        }

        if (data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Image.network('$baseAssetsUrl/${data[index]}');
          },
        );
      },
    );
  }
}
