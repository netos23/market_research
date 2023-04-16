import 'package:flutter/material.dart';
import 'package:web_page/data/picture_service.dart';
import 'package:web_page/types.dart';

class PictureGroupsScreen extends StatefulWidget {
  const PictureGroupsScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  final PictureService service;

  @override
  State<PictureGroupsScreen> createState() => _PictureGroupsScreenState();
}

class _PictureGroupsScreenState extends State<PictureGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.service.getPictureGroups(),
      builder: (context, snap) {
        final data = snap.data?.groups;

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

        return CustomScrollView(
          slivers: [
            for (var i = 0; i < data.length; i++) ...[
              SliverToBoxAdapter(
                child: Text('Группа $i'),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Image.network('$baseAssetsUrl/${data[i][index]}');
                }, childCount: data[i].length),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}
