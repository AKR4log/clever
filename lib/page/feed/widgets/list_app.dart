// ignore_for_file: unused_local_variable

import 'package:clever/page/feed/widgets/preview_app.dart';
import 'package:clever/utils/mdls/app/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListApp extends StatefulWidget {
  const ListApp({Key key}) : super(key: key);

  @override
  _ListAppState createState() => _ListAppState();
}

class _ListAppState extends State<ListApp> {
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<List<Application>>(context);
    return app.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : GridView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1),
            itemCount: app.length,
            itemBuilder: (context, index) {
              return PreviewApp(application: app[index]);
            },
          );
  }
}
