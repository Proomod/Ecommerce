import 'package:eatziffy/constants.dart';
import 'package:flutter/material.dart';

class BaseAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppbar({Key? key, required this.title, this.centerTitle = true})
      : super(key: key);
  final Widget title;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 160.0,
      automaticallyImplyLeading: true,
      title: title,
      backgroundColor: Color(0xFFFF903F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(23.0),
          bottomRight: Radius.circular(23.0),
        ),
      ),
      centerTitle: centerTitle,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(142, 254, 219, 194),
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('What bookmarks are you searching for?',
                    style: TextStyle(
                      color: kWhiteColor,
                    ))
              ]),
            ),
          ),
        ),
      ),
      actions: [
        Align(
          alignment: Alignment.topCenter,
          child: IconButton(
            onPressed: () {},
            icon: ImageIcon(AssetImage('assets/icons/cil_bell.png')),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(160.0);
}
