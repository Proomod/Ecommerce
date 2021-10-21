import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatziffy/constants.dart';
import 'package:eatziffy/models/categories.dart';
import 'package:eatziffy/models/items.dart';
import 'package:eatziffy/models/labels.dart';
import 'package:eatziffy/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

//i usually make widget stateless and make api calls by making repositories and
//implementing bloc to interact wwith the ui

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.category}) : super(key: key);
  final CategoriesModel category;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<List<Label>>? _labels;
  Label? currentSelectedLabel;
  @override
  void initState() {
    super.initState();
    _labels = _loadLabels();
  }

  Future<List<Label>> _loadLabels() async {
    List<Label> labels = [];
    String url = '$kBaseurl/labels/?catId=${widget.category.categoryId}';
    final http.Response response = await http
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    final List<dynamic> labelJson = jsonDecode(response.body);

    labelJson.forEach((label) => labels.add(Label.fromJson(label)));

    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: BaseAppbar(
        title: Text(widget.category.name),
        centerTitle: true,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 13.0,
          ),
          child: Text(
            'Label',
            style: TextStyle(
              color: kBlackTitleColor,
              fontWeight: FontWeight.w700,
              fontSize: 19.0,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder<List<Label>>(
              future: _labels,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Label>> snapshot) {
                List<Widget> children = [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(50.0, 30),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                          ),
                          side: BorderSide(
                            style: BorderStyle.solid,
                            color: kButtonDisabledBorderColor,
                            width: 2,
                          )),
                      child: Icon(
                        Icons.add,
                        color: kButtonDisabledBorderColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ];
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    children = [
                      SizedBox(
                        height: 6.0,
                        width: MediaQuery.of(context).size.width,
                        child: LinearProgressIndicator(
                            minHeight: 4.0,
                            color: Colors.blue,
                            backgroundColor: kButtonDisabledBorderColor),
                      ),
                    ];
                    break;
                  case (ConnectionState.done):
                    if (snapshot.hasData) {
                      children.addAll(snapshot.data!
                          .map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    minimumSize: Size(50.0, 30),
                                    primary: Colors.white,
                                    backgroundColor:
                                        currentSelectedLabel?.labelId ==
                                                item.labelId
                                            ? kButtonActiveColor
                                            : kButtonDisabledBorderColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        20.0,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      currentSelectedLabel = item;
                                    });
                                    print(currentSelectedLabel?.name);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(item.name),
                                  ),
                                ),
                              ))
                          .toList());
                    } else if (snapshot.hasError) {
                      children = [Center(child: Text("Can't load levels now"))];
                    }
                    break;
                  default:
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: children,
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bookmarks',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w700,
                        color: kBlackTitleColor,
                      ),
                    ),
                    ImageIcon(
                      AssetImage(
                          'assets/icons/fluent_arrow-swap-20-regular.png'),
                      color: kButtonActiveColor,
                      size: 32.0,
                    )
                  ],
                ),
                Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons/bi_bookmark.png'),
                      color: kButtonActiveColor,
                    ),
                    Text(widget.category.totalBookmarked.toString(),
                        style: TextStyle(
                          color: kButtonActiveColor,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
        currentSelectedLabel != null
            ? Items(
                label: currentSelectedLabel ?? Label.empty,
                categoryId: widget.category.categoryId)
            : Expanded(
                child: Center(child: Text('Please select a label')),
              )
      ]),
    );
  }
}

class Items extends StatefulWidget {
  const Items({
    required this.label,
    required this.categoryId,
    Key? key,
  }) : super(key: key);
  final Label label;
  final int categoryId;

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Future<List<ItemModel>>? _items;
  @override
  void didChangeDependencies() {
    _items = _getItems();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Items oldWidget) {
    _items = _getItems();
    super.didUpdateWidget(oldWidget);
  }

  Future<List<ItemModel>> _getItems() async {
    String url =
        '$kBaseurl/items/?labelId=${widget.label.labelId}&catId=${widget.categoryId}';
    List<ItemModel> items = [];
    try {
      final http.Response httpResponse = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      final jsonItem = jsonDecode(httpResponse.body);
      jsonItem.forEach((item) => items.add(ItemModel.fromJson(item)));
    } catch (e) {
      throw Exception(e);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<ItemModel>>(
          initialData: [],
          future: _items,
          builder:
              (BuildContext context, AsyncSnapshot<List<ItemModel>> snapshot) {
            List<Widget> children = <Widget>[];
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                children = [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ];
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 0) {
                    children = [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: Text('No items for this label'),
                        ),
                      )
                    ];
                  }
                  children.addAll(snapshot.data!
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, left: 8.0, right: 8.0),
                          child: Card(
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: CachedNetworkImage(
                                        memCacheHeight: 58,
                                        memCacheWidth: 60,
                                        imageUrl: item.imageUrl,
                                        height: 58,
                                        width: 60,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        color: kBlackTitleColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              item.isFavorite =
                                                  !item.isFavorite;
                                            });
                                            await _toggleStatus(item);
                                          },
                                          child: ImageIcon(
                                            AssetImage(
                                                'assets/icons/star_empt.png'),
                                            color: item.isFavorite
                                                ? kIconActiveColor
                                                : kButtonDisabledBorderColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              item.isBookmarked =
                                                  !item.isBookmarked;
                                            });
                                            await _toggleStatus(item);
                                          },
                                          child: ImageIcon(
                                            AssetImage(
                                              'assets/icons/bell_empt.png',
                                            ),
                                            color: item.isBookmarked
                                                ? kBellActiveButton
                                                : kButtonDisabledBorderColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          color: kIconActiveColor,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ImageIcon(
                                            AssetImage(
                                                'assets/icons/system-uicons_door-alt.png'),
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                      SizedBox(width: 6.0),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              snapshot.data!.remove(item);
                                            });
                                            await _removeItem(item);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: kDeleteButtonColor,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ImageIcon(
                                                AssetImage(
                                                    'assets/icons/lucide_trash.png'),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList());
                }
                break;
              default:
                break;
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: children,
              ),
            );
          }),
    );
  }

  Future<void> _toggleStatus(ItemModel item) async {
    String url = '$kBaseurl/items/${item.itemId}';
    try {
      var response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()),
      );
      var data = jsonDecode(response.body);
      print(data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _removeItem(ItemModel item) async {
    String url = '$kBaseurl/items/${item.itemId}';

    try {
      final http.Response response = await http.delete(Uri.parse(url));
    } on Exception catch (e) {}
  }
}
