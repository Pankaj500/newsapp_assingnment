import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managemant/controllers/headline_controller.dart';
import 'package:task_managemant/feature/categories.dart';
import 'package:task_managemant/feature/like_section.dart';
import 'package:task_managemant/feature/news_detail_screen.dart';
import 'package:task_managemant/models/headline_model.dart';

final isloading = StateProvider((ref) => false);

final filteredlistprovider = StateProvider<List<Articles>>((ref) => []);

final likevalueprovider = StateNotifierProvider<LikeIcon, List<bool>>(
  (ref) => LikeIcon(),
);

class LikeIcon extends StateNotifier<List<bool>> {
  LikeIcon() : super(List.generate(20, (index) => false));

  void changebool(index) {
    state[index] = !state[index];
    state = [...state];
  }
}

final savedArticlesProvider =
    StateNotifierProvider<SavedArticlesNotifier, List<Articles>>((ref) {
  return SavedArticlesNotifier();
});

class SavedArticlesNotifier extends StateNotifier<List<Articles>> {
  SavedArticlesNotifier() : super([]) {
    _loadSavedArticles();
  }

  Future<void> _loadSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedArticles =
        prefs.getStringList('saved_articles') ?? [];
    state = savedArticles
        .map((article) => Articles.fromJson(json.decode(article)))
        .toList();
  }

  Future<void> saveArticle(Articles article) async {
    if (!state.any((savedArticle) => savedArticle.url == article.url)) {
      state = [...state, article];
      await _saveToPreferences();
    }
  }

  Future<void> removeArticle(Articles article) async {
    state =
        state.where((savedArticle) => savedArticle.url != article.url).toList();
    await _saveToPreferences();
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedArticles =
        state.map((article) => json.encode(article.toJson())).toList();
    await prefs.setStringList('saved_articles', savedArticles);
  }
}

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final headline = ref.watch(headlineprovider);
    final loading = ref.watch(isloading);

    final news = ref.watch(dataprovider);

    var likebool = ref.watch(likevalueprovider);

    final savedarticle = ref.watch(savedArticlesProvider);

    void _filterArticles(String query) {
      final filtered = news.where((article) {
        final titleLower = article.title!.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
      ref.read(headlineprovider.notifier).state = filtered;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text(
            'News App',
            style: TextStyle(),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.01),
              const CategoriesPage(),
              loading
                  ? Padding(
                      padding: EdgeInsets.only(top: height * 0.4),
                      child: const CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: width * 0.03, right: width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.8,
                                child: TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Search',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (query) {
                                    _filterArticles(query);
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LikeSection()));
                                },
                                child: Icon(
                                  Icons.favorite,
                                  size: height * 0.05,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: headline.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewDetailScreen(
                                              newsindex: index)));
                                },
                                onDoubleTap: () {
                                  ref
                                      .read(likevalueprovider.notifier)
                                      .changebool(index);
                                  if (likebool[index] == true) {
                                    ref
                                        .read(savedArticlesProvider.notifier)
                                        .saveArticle(headline[index]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'data added to like section')),
                                    );
                                  } else {
                                    ref
                                        .read(savedArticlesProvider.notifier)
                                        .removeArticle(headline[index]);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: width * 0.03,
                                    right: width * 0.03,
                                    top: height * 0.01,
                                  ),
                                  child: Container(
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: height * 0.3,
                                              width: width,
                                              child: headline[index]
                                                          .urlToImage ==
                                                      null
                                                  ? const Center(
                                                      child: Text(
                                                          'No image for the news'))
                                                  : Image.network(
                                                      '${headline[index].urlToImage}',
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: likebool[index]
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.white,
                                                      )),
                                          ],
                                        ),
                                        const Text(
                                          'Headline',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(headline[index].title.toString()),
                                        const Text(
                                          'Source',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(headline[index]
                                            .source!
                                            .name
                                            .toString()),
                                        const Text(
                                          'Published at',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(headline[index]
                                            .publishedAt
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
            ],
          ),
        ));
  }
}
