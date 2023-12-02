import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

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
  Uint8List? _fileBytes;
  double _uploadProgress = 0.0;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        Uint8List fileBytes = result.files.first.bytes!;
        setState(() {
          _fileBytes = fileBytes;
        });
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> _uploadFile() async {
    if (_fileBytes == null) {
      // No file selected
      _showSnackBar("Please select a file first.");
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
      final fileName =
          'files/$userId'; // You can customize the file path and name here

      final storageRef = _storage.ref().child(fileName);
      final uploadTask = storageRef.putData(_fileBytes!);

      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          setState(() {
            _uploadProgress = progress;
          });
        },
      );

      await uploadTask.whenComplete(() {
        // File uploaded successfully
        _showSnackBar('File uploaded to Firebase Storage');
        setState(() {
          _uploadProgress = 0.0; // Reset progress after completion
        });
      });
    } catch (e) {
      // Handle errors
      print('Error uploading file: $e');
      _showSnackBar('Error uploading file: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fileBytes == null
                ? Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.insert_drive_file,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  )
                : Icon(
                    Icons.insert_drive_file,
                    size: 100,
                    color: Colors.blue,
                  ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.attach_file),
              label: Text('Select File'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
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
