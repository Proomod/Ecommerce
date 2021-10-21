import 'package:flutter/material.dart';

import 'homepage/homepage.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: <String, Widget Function(BuildContext)>{
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// class Testpage extends StatefulWidget {
//   const Testpage({Key? key}) : super(key: key);

//   @override
//   _TestpageState createState() => _TestpageState();
// }

// class _TestpageState extends State<Testpage> {
//   File? myimage;
//   Future<File?> _pickImage() async {
//     final _picker = ImagePicker();
//     try {
//       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       final File file = File(image!.path);
//       setState(() {
//         myimage = file;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _fakeReqest() async {
//     //first ma parse a url
//     var url = Uri.parse('http://google.com');
//     //pick a image from gallery

//     //then create a multipart request
//     var request = http.MultipartRequest('POST', url)
//       ..fields['something goes here'] = "ssomething stupid should go here";
//     await _pickImage();
//     if (myimage != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath('image',
//             myimage!.path), // get image file path from gallery or any handle
//       );
//     }
//     print(request.files);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xfffffff),
//         title: Text('Hello world'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () => Navigator.pushNamed(context, '/home'),
//               icon: Icon(
//                 Icons.home,
//                 color: Colors.black,
//               ))
//         ],
//       ),
//       body: SafeArea(
//         child: Column(children: [
//           Text('write something here'),
//           SizedBox(
//             height: MediaQuery.of(context).size.height / 2,
//             width: double.infinity,
//             child: myimage != null
//                 ? Image.file(
//                     myimage!,
//                   )
//                 : Container(
//                     color: Colors.grey,
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.camera_alt),
//                           Text('click to add image'),
//                         ]),
//                   ),
//           ),
//           ElevatedButton(
//               onPressed: () async {
//                 await _fakeReqest();
//               },
//               child: Text('Upload image')),
//         ]
//             //place items here according to th needs
//             ),
//       ),
//     );
//   }
// }

// Future<File> getImageFromAsset() async {
//   final bytedata = await rootBundle.load('images/testimage.jpg');
//   print(bytedata.lengthInBytes);
//   var path = (await getTemporaryDirectory()).path;
//   final file = File('$path/images/testimage.jpg');
//   print(file.path);
//   try {
//     await file.writeAsBytes(bytedata.buffer
//         .asUint8List(bytedata.offsetInBytes, bytedata.lengthInBytes));
//   } catch (e) {
//     print(e);
//   }

//   return file;
// }
