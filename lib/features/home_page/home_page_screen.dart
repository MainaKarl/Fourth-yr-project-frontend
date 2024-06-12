import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lip_reading/core/helpers/extensions.dart';
import 'package:lip_reading/core/routing/routes.dart';
import 'package:lip_reading/core/theming/colors.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:open_file/open_file.dart';
import 'widgets/lip_reading_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


enum ToastStates {
  SUCCESS,
  ERROR,
  WARNIING,
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  PlatformFile? _pickedFile;
  var generatedText = '';
  bool isError = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String? fileName = _pickedFile != null ? _pickedFile!.name : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('home page'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.pushNamedAndRemoveUntil(Routes.loginScreen,
                  predicate: (Route<dynamic> route) => false);
            },
            icon: const Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            if (fileName != null)
              Text('Chosen File: $fileName'),
            if (fileName == null)
              const Text('No file chosen'),
            LipReadingText(
              generatedText: generatedText,
            ),
            SizedBox(
              height: 20.h,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      PlatformFile? pickedFile = await pickVideoFile();
                      if (pickedFile != null) {
                        setState(() {
                          _pickedFile = pickedFile;
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(ColorsManager.mainBlue),
                    ),
                    child: const Text(
                      'Choose File',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_pickedFile != null) {
                        // connectAndSendData(_pickedFile!);
                        setState(() {
                          _isLoading = true;
                        });
                        showLoadingDialog(context);
                        await connectAndSendData(_pickedFile!);
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      } else {
                        print("No file selected");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(ColorsManager.mainBlue),
                    ),
                    child: const Text(
                      'Generate Text',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<PlatformFile?> pickVideoFile() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      // File file = File(result.files.single.path!);
      final file = result.files.first;
      openFile(file);
      return file;
    } else {
      // User canceled the picker
      return null;
    }
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void showLoadingDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text("Loading....")
                ],
              ),
            ),
          );
        },
    );
  }

//   void connectAndSendData(PlatformFile file) async {
//     print("Attempting to connect to socket...");
//     try {
//       // Establish socket connection
//       Socket socket = await Socket.connect("127.0.0.1", 5000);
//       print('Connected to socket!');
//
//       // Example: Send data
//       socket.write(file.name);
//
//       // Read file as bytes
//       List<int> fileBytes = await File(file.path!).readAsBytes();
//
//       socket.write(fileBytes.length);
//
//       socket.add(fileBytes);
//
//       socket.write("<END>");
//
//       print("done");
//
//       // Example: Listen for responses
//       socket.listen((List<int> data) {
//         if (String.fromCharCodes(data) == 'ERROR') {
//           setState(() {
//             isError = true;
//           });
//         }
//
//         if (String.fromCharCodes(data) != '' && !isError) {
//           showToast(text: 'Success generated', state: ToastStates.SUCCESS);
//           setState(() {
//             generatedText = String.fromCharCodes(data);
//           });
//         } else {
//           showToast(text: generatedText, state: ToastStates.ERROR);
//         }
//         print(generatedText);
//         print('Received data: ${String.fromCharCodes(data)}');
//         // Handle received data here
//       });
//
//       // Close the socket when done
//       socket.close();
//     } catch (e) {
//       print('Error connecting to socket: $e');
//       // Handle error
//     }
//   }
// }

  Future <void> connectAndSendData(PlatformFile file) async {
    print("Attempting to send data to backend...");
    try {
      // Save the picked file to the device's storage
      final String filePath = await saveFileToDeviceStorage(file);

      // Prepare the request body
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://fourth-yr-project-production.up.railway.app/video'), // Update the URL with your backend endpoint
        Uri.parse('https://7f4c-154-70-54-99.ngrok-free.app/video'),
      );

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        filePath,
      ));

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the response
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);

        if (responseData.containsKey('transcription')) {
          // Update UI with transcription
          setState(() {
            generatedText = responseData['transcription'];
          });
          showToast(text: 'Success generated', state: ToastStates.SUCCESS);
        } else {
          showToast(text: 'Error: Transcription not found', state: ToastStates.ERROR);
        }
      } else {
        showToast(text: 'Error: ${response.reasonPhrase}', state: ToastStates.ERROR);
      }
    } catch (e) {
      print('Error sending data to backend: $e');
      showToast(text: 'Error: $e', state: ToastStates.ERROR);
    }
  }

  Future<String> saveFileToDeviceStorage(PlatformFile file) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${file.name}';
    final fileBytes = await File(file.path!).readAsBytes(); // Read file as bytes directly
    final tempFile = File(filePath);
    await tempFile.writeAsBytes(fileBytes);
    return filePath;
  }



void showToast({
  required String text,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}



Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNIING:
      color = Colors.amber;
      break;
  }
  return color;
}
}
