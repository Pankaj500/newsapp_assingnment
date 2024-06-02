import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'homepage.dart';
import 'news_detail_screen.dart';

class FilterData extends ConsumerWidget {
  const FilterData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fiteredlist = ref.watch(filteredlistprovider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: fiteredlist.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewDetailScreen(newsindex: index)));
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.3,
                          width: width,
                          child: fiteredlist[index].urlToImage == null
                              ? const Center(
                                  child: Text('Error loading the Image'))
                              : Image.network(
                                  '${fiteredlist[index].urlToImage}',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const Text(
                          'Headline',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(fiteredlist[index].title.toString()),
                        const Text(
                          'Source',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(fiteredlist[index].source!.name.toString()),
                        const Text(
                          'Published at',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(fiteredlist[index].publishedAt.toString()),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
