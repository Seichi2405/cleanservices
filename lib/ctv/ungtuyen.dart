import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../ctv/profile_page_ctv.dart';
import '../ctv/ungtuyen2.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class ungtuyen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Application',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ứng tuyển'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePageCTV(),
                ),
              );
            },
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  AvatarWidget(),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Ngan',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'CV ứng tuyển',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Vui lòng gửi CV để ứng tuyển, dung lượng file không vượt quá 5MB và kèm ảnh CMND/CCCD',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload),
                  SizedBox(width: 10),
                  Text(
                    'CMND/CCCD',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 30),
                  Icon(Icons.file_upload),
                  SizedBox(width: 10),
                  Text(
                    'Tải tệp lên',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(),
                    ),
                  );
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(
              'https://toigingiuvedep.vn/wp-content/uploads/2021/01/anh-avatar-cho-con-gai-cuc-dep.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

// --test 1---
// void uploadImage() async {
//   var image = await ImagePicker().getImage(source: ImageSource.gallery);
//   if (image != null) {
//     final String fileName = path.basename(image.path);
//     final String destinationDir = 'D:/hinh';
//     final String destinationPath = '$destinationDir/$fileName';

//     // Create the destination directory if it doesn't exist
//     Directory(destinationDir).createSync(recursive: true);

//     await File(image.path).copy(destinationPath);

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://127.0.0.1:8000/docs#/default/predict_api_predict_image_post'),
//     );
//     request.files.add(await http.MultipartFile.fromPath(
//       'image',
//       destinationPath,
//       contentType:
//           MediaType.parse(lookupMimeType(destinationPath) ?? 'image/jpeg'),
//     ));

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       // Handle the response from the server
//     }
//   }
// }

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   Future<void> takePicture() async {
//     var image = await ImagePicker().getImage(source: ImageSource.camera);
//     if (image != null) {
//       final String fileName = path.basename(image.path);
//       final String destinationDir = 'D:/hinh';
//       final String destinationPath = '$destinationDir/$fileName';

//       // Create the destination directory if it doesn't exist
//       Directory(destinationDir).createSync(recursive: true);

//       await File(image.path).copy(destinationPath);

//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://127.0.0.1:8000/predict/image'),
//       );
//       request.files.add(await http.MultipartFile.fromPath(
//         'image',
//         destinationPath,
//         contentType:
//             MediaType.parse(lookupMimeType(destinationPath) ?? 'image/jpeg'),
//       ));

//       var response = await request.send();
//       if (response.statusCode == 200) {
//         // Handle the response from the server
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: takePicture,
//           child: Text('Take Picture'),
//         ),
//       ),
//     );
//   }
// }
// -----------------------------

// ---Test2-----
void uploadImage(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:8000/predict/image'),
  );
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Image uploaded successfully');
    // Xử lý phản hồi từ server (nếu cần)
  } else {
    print('Image upload failed with status code: ${response.statusCode}');
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Future<void> takePicture() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      uploadImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: takePicture,
          child: Text('Take Picture'),
        ),
      ),
    );
  }
}
