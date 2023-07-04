import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/screens/webview_screen.dart';

import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  ArticleDetailScreen(this.article, this.index, {super.key}) {
    DateTime date = DateTime.parse(article.publishedAt!);
    var formatter = DateFormat('yMd').add_Hm();
    publishedAtStr = formatter.format(date);
  }

  final Article article;
  final int index;
  late final String publishedAtStr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe0f1ff),
        // title: const Text(''),
        actions: [
          IconButton(
            tooltip: 'see on site',
            icon: const Icon(Icons.link),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => WebViewScreen(article: article)),
              );
            },
          )
        ],
      ),
      body: Container(
        color: const Color(0xffe0f1ff),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              Text(
                article.title ?? '',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0.0),
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text('Published by'),
                subtitle: Text(article.author ?? ''),
              ),
              Text(
                article.content ?? '',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 16.0),
              Hero(
                tag: 'news_hero_$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: article.urlToImage == null
                      ? Image.asset('assets/images/default_news_3.jpeg')
                      : Image.network(
                          article.urlToImage!,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/default_news_2.jpeg'),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
