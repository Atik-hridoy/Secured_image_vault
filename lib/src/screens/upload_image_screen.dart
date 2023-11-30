import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UploadImageScreen(),
    );
  }
}

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _imageBytes;
  double _uploadProgress = 0.0;

  Future<void> _pickImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..click();

    input.onChange.listen((html.Event e) {
      final html.File file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageBytes = reader.result as Uint8List;
        });
      });
    });

    input.click();
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) {
      // No image selected
      _showSnackBar("Please select an image first.");
      return;
    }

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        // No signed-in user
        _showSnackBar("No signed-in user.");
        return;
      }

      final userId = currentUser.uid;
      final imagePath = 'images/$userId.png';

      final storageRef = _storage.ref().child(imagePath);
      final uploadTask = storageRef.putData(_imageBytes!);

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      await uploadTask.whenComplete(() {
        // Image uploaded successfully
        _showSnackBar('Image uploaded to Firebase Storage');
        setState(() {
          _uploadProgress = 0.0; // Reset progress after completion
        });

        // Show success dialog
        _showSuccessDialog();
      });
    } catch (e) {
      // Handle errors
      print('Error uploading image: $e');
      _showSnackBar('Error uploading image: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Image successfully uploaded.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes == null
                ? Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  )
                : Image.memory(
                    _imageBytes!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Select Image'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              child: LinearProgressIndicator(
                value: _uploadProgress,
                minHeight: 10,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
