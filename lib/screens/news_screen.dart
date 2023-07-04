import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/filter_provider.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/screens/article_detail_screen.dart';
import 'package:news/screens/filter/news_filter_screen.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  late NewsProvider np;
  late FilterProvider fp;

  @override
  void initState() {
    super.initState();
    np = Provider.of<NewsProvider>(context, listen: false);
    fp = Provider.of<FilterProvider>(context, listen: false);
    _scrollController.addListener(_loadNews);

    np.getArticles(fp.filter);
  }

  void _loadNews() {
    if (np.isLoading == false &&
        np.hasNextPage &&
        _scrollController.offset + 100 >
            _scrollController.position.maxScrollExtent) {
      np.isLoading = true;
      np.notify();
      if (kDebugMode) {
        print('news loading...');
      }
      fp.filter.page = np.page;
      np.getArticles(fp.filter, clearNews: false);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.removeListener(_loadNews);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0f1ff),
      appBar: appBar(context),
      body: _body,
    );
  }

  Consumer get _body {
    return Consumer<NewsProvider>(
      builder: (context, value, child) => ListView.separated(
        separatorBuilder: (_, __) => const Divider(height: 2.0),
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        itemCount: value.articles.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetailScreen(value.articles[index], index)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListTile(
              leading: Hero(
                tag: 'news_hero_$index',
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: value.articles[index].urlToImage == null
                        ? Image.asset(
                            'assets/images/default_news_3.jpeg',
                            fit: BoxFit.fitWidth,
                          )
                        : Image.network(
                            value.articles[index].urlToImage!,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                    'assets/images/default_news_2.jpeg'),
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
              ),
              title: Text(value.articles[index].title ?? ''),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffe0f1ff),
      leading: context.watch<NewsProvider>().isSearching
          ? IconButton(
              icon: const Icon(Icons.keyboard_backspace_outlined),
              tooltip: 'Back',
              onPressed: () {
                fp.filter.q = null;
                _textController.clear();
                np.isSearching = !np.isSearching;
                np.backArticle();
              },
            )
          : null,
      title: context.watch<NewsProvider>().isSearching
          ? SizedBox(
              width: double.maxFinite,
              child: TextField(
                autofocus: true,
                controller: _textController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'type for searching',
                ),
                onSubmitted: (value) {
                  fp.filter.q = value.trim();
                  np.getArticles(fp.filter, isFilter: true);
                },
              ),
            )
          : const Text('News'),
      actions: <Widget>[
        IconButton(
          icon: Icon(np.isSearching ? Icons.cancel : Icons.search),
          tooltip: 'Search',
          onPressed: () {
            if (np.isSearching) {
              _textController.clear();
            } else {
              np.isSearching = !np.isSearching;
              np.notify();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter),
          tooltip: 'Filter',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const NewsFilterScreen();
              },
              isDismissible: false,
            );
          },
        ),
      ],
    );
  }
}
