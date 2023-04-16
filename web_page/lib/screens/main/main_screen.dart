import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_page/data/picture_service.dart';
import 'package:web_page/screens/picture_groups/picture_groups_screen.dart';
import 'package:web_page/screens/picture_list/picture_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ValueNotifier<int> tab = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final service = context.read<PictureService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск товаров'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Поиск товаров'),
            ),
            ListTile(
              title: const Text('Список продуктов'),
              onTap: () {
                tab.value = 0;
              },
            ),
            ListTile(
              title: const Text('Группы продуктов'),
              onTap: () {
                tab.value = 1;
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: tab,
        builder: (context, value, _) {
          return IndexedStack(
            index: value,
            children: [
              PictureListScreen(future: service.getPictures()),
              PictureGroupsScreen(service: service)
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.of(context).pushNamed('/search'),
        child: const Icon(
          Icons.search
        ),
      ),
    );
  }

  @override
  void dispose() {
    tab.dispose();
    super.dispose();
  }
}
