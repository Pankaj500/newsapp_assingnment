import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/feature/homepage.dart';

class LikeSection extends ConsumerWidget {
  const LikeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var list = ref.watch(savedArticlesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked News'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: list.length == 0
          ? Center(
              child: Text(
                'There is no data in like section ',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.03,
                    right: width * 0.03,
                    top: height * 0.01,
                  ),
                  child: Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: height * 0.3,
                              width: width,
                              child: list[index].urlToImage == null
                                  ? const Center(
                                      child: Text('Error loading the Image'))
                                  : Image.network(
                                      '${list[index].urlToImage}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(savedArticlesProvider.notifier)
                                    .removeArticle(list[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.83, top: width * 0.03),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Text(
                          'Headline',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(list[index].title.toString()),
                        const Text(
                          'Source',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(list[index].source!.name.toString()),
                        const Text(
                          'Published at',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(list[index].publishedAt.toString()),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
