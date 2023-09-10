import 'package:flutter/material.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  _ArticlesPage createState() => _ArticlesPage();
}

class _ArticlesPage extends State<ArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Articles page")));
  }
}
