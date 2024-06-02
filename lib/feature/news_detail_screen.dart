import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/controllers/headline_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class NewDetailScreen extends ConsumerWidget {
  const NewDetailScreen({super.key, required this.newsindex});

  final int newsindex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final news = ref.watch(headlineprovider);

    void _launchURL(String url) async {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $_url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                  height: height * 0.4,
                  width: width,
                  child: news[newsindex].urlToImage == null
                      ? Center(child: Text('No Image for the News'))
                      : Image.network(
                          news[newsindex].urlToImage.toString(),
                          fit: BoxFit.cover,
                        )),
              const Text(
                'Headline',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(news[newsindex].title.toString()),
              const Text(
                'Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                news[newsindex].source!.name.toString(),
              ),
              const Text(
                'Published date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(news[newsindex].publishedAt.toString()),
              const Text(
                'Author Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(news[newsindex].author.toString()),
              const Text(
                'Content',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                news[newsindex].content.toString(),
              ),
              const Text(
                'link',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(news[newsindex].url.toString());
                },
                child: Text(news[newsindex].url.toString(),
                    style: const TextStyle(color: Colors.blue)),
              ),
              SizedBox(
                height: height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
