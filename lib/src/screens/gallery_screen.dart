import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'upload_image_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Replace with a method that fetches the list of folders from Firestore or any other data source.
  Future<List<String>> listFolders() async {
    // Implement your logic to fetch folders
    // For now, return a sample list.
    return ['Folder1', 'Folder2', 'Folder3'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        backgroundColor: Colors.blue, // Customize the color as needed
      ),
      body: FutureBuilder<List<String>>(
        future: listFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No folders available.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FolderTile(folderName: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}

class FolderTile extends StatelessWidget {
  final String folderName;

  const FolderTile({Key? key, required this.folderName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(folderName),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilesInFolderScreen(folderName: folderName)),
        );
      },
    );
  }
}

class FilesInFolderScreen extends StatelessWidget {
  final String folderName;

  const FilesInFolderScreen({Key? key, required this.folderName}) : super(key: key);

  // Replace with a method that fetches the list of files in this folder from Firestore or any other data source.
  Future<List<String>> listFilesInFolder(String folderName) async {
    // Implement your logic to fetch files in this folder
    // For now, return a sample list.
    return ['File1.txt', 'File2.jpg', 'File3.pdf'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: FutureBuilder<List<String>>(
        future: listFilesInFolder(folderName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No files available in this folder.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FileTile(fileName: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}

class FileTile extends StatelessWidget {
  final String fileName;

  const FileTile({Key? key, required this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fileName),
      onTap: () {
        // Implement what should happen when tapping on a file
      },
    );
  }
}
