import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/feature/homepage.dart';
import 'package:task_managemant/repositeries/categories_repo.dart';
import 'package:task_managemant/repositeries/headlines_api.dart';
import 'package:task_managemant/utils/apis.dart';

final catindexprovider = StateProvider((ref) => 0);

final countryprovider = StateProvider((ref) => 'in');

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    List<String> list = [
      'India',
      'United State',
      'England',
      'Pakistan',
      'South Africa',
    ];
    List<String> value = [
      'in',
      'us',
      'ph',
      'eg',
      'sa',
    ];
    var cat = ref.watch(catindexprovider);
    return Column(
      children: [
        SizedBox(
          height: height * 0.05,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              //physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    ref.read(catindexprovider.notifier).state = index;
                    ref.read(countryprovider.notifier).state = value[index];

                    HeadlinesApiRepo().getheadlines(ref, context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: height * 0.01),
                    child: Container(
                      height: height * 0.05,
                      decoration: BoxDecoration(
                          color: index == cat ? Colors.blue : Colors.white,
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: Text(
                            list[index],
                            style: TextStyle(
                                fontSize: 18,
                                color:
                                    index == cat ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
