import 'dart:convert';

import 'package:eatziffy/CookingPage/view/cookingpage_view.dart';
import 'package:eatziffy/constants.dart';
import 'package:http/http.dart' as http;
import 'package:eatziffy/models/categories.dart';
import 'package:eatziffy/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<CategoriesModel>>? _categories;
  bool hasError = false;

  //make a call to categories and name api during this page initialization
  //this is usually separated and called with Bloc pattern but since this is demo app and we have a singular flow of page
  // it would be okay to call the http here
  Future<List<CategoriesModel>> loadNameAndCatagories() async {
    const String url = '$kBaseurl/categories';
    final List<CategoriesModel> categories = [];
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      data.forEach(
          (category) => categories.add((CategoriesModel.fromJson(category))));
      print(data);
    } catch (e) {
      setState(() {
        hasError = true;
      });
      print(hasError);
    }
    return categories;
  }

  @override
  void initState() {
    super.initState();
    _categories = loadNameAndCatagories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi John'),
            SizedBox(height: 13.0),
            Text('Welcome back!'),
          ],
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<List<CategoriesModel>>(
        future: _categories,
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoriesModel>> snapshot) {
          Widget child = Center(child: CircularProgressIndicator());
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              child = Center(
                child: Text('Unable to connect to server'),
              );
              break;
            case ConnectionState.waiting:
              child = Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              print('connection done');
              if (snapshot.hasData) {
                if (snapshot.data!.length == 0) {
                  child = Center(
                    child: Text('No categories found'),
                  );
                } else {
                  child = Categories(categories: snapshot.data);
                }

                break;
              } else if (snapshot.hasError) {
                child = Center(
                  child: Text('Cannot connect now please try again later'),
                );
              }
          }
          return child;
        },
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    required categories,
    Key? key,
  })  : _categories = categories,
        super(key: key);
  final List<CategoriesModel> _categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
          ),
          child: Text(
            'Categories',
            style: TextStyle(
              color: kCategoriesColor,
              fontSize: 19.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: [
                GridItem(
                  containerIconPath: kMonitorIconPath,
                  category: _categories[0],
                  containerColor: kIdeasColor,
                  innerContentColor: kIdeasInnerColor,
                ),
                GridItem(
                    containerIconPath: kHamburgerIconPath,
                    containerColor: kCookingColor,
                    category: _categories[1],
                    innerContentColor: kCookingInnerColor),
                GridItem(
                  category: _categories[2],
                  containerIconPath: kMonitorIconPath,
                  innerContentColor: kProgrammingInnerColor,
                  containerColor: kProgrammingColor,
                ),
                GridItem(
                  innerContentColor: kMusicInnerColor,
                  containerColor: kMusicColor,
                  category: _categories[3],
                  containerIconPath: kHamburgerIconPath,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    Key? key,
    required this.containerColor,
    required this.innerContentColor,
    required this.containerIconPath,
    required this.category,
  }) : super(key: key);

  final Color containerColor;
  final Color innerContentColor;
  final String containerIconPath;

  final CategoriesModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    color: kInnerCircleColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                      iconSize: 100,
                      icon: ImageIcon(
                        AssetImage(
                          containerIconPath,
                        ),
                        color: innerContentColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                category: category,
                              ),
                            ));
                      }),
                )),
            SizedBox(
              height: 8.0,
            ),
            Text(
              category.name,
              style: TextStyle(
                color: innerContentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    );
  }
}
