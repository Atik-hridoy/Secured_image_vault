import 'package:flutter/material.dart';
import 'package:secured_image_vault/screens/upload_image_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        backgroundColor: Colors.blue, // Customize the app bar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Main Screen!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadImageScreen()),
                );
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
