import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryScreen extends StatefulWidget {
  final String userId;

  const GalleryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                return FolderTile(
                  folderName: snapshot.data![index],
                  userId: widget.userId,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateFolderDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _folderNameController = TextEditingController();

        return AlertDialog(
          title: Text('Create Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: InputDecoration(labelText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String folderName = _folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  _createFolder(folderName, widget.userId);
                  Navigator.pop(context);
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createFolder(String folderName, String userId) {
    // Save the folder name to Firestore
    _firestore
        .collection('users')
        .doc(userId)
        .collection('folders')
        .doc(folderName)
        .set({
      'name': folderName,
    });

    // Add the folder to the local list for immediate UI update
    setState(() {
      // Add the folder name to the list
    });
  }
}

class FolderTile extends StatelessWidget {
  final String folderName;
  final String userId;

  const FolderTile({Key? key, required this.folderName, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(folderName),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FilesInFolderScreen(folderName: folderName, userId: userId)),
        );
      },
    );
  }
}

class FilesInFolderScreen extends StatelessWidget {
  final String folderName;
  final String userId;

  const FilesInFolderScreen(
      {Key? key, required this.folderName, required this.userId})
      : super(key: key);

  // Replace with a method that fetches the list of files in this folder from Firestore or any other data source.
  Future<List<String>> listFilesInFolder(
      String folderName, String userId) async {
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
        future: listFilesInFolder(folderName, userId),
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
