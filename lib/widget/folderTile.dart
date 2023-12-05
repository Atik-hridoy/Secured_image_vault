import 'package:flutter/material.dart';
import 'package:secured_image_vault/src/screens/gallery_screen.dart';

class FolderTile extends StatefulWidget {
  final String folderName;

  const FolderTile({Key? key, required this.folderName}) : super(key: key);

  @override
  _FolderTileState createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  late TextEditingController _folderNameController;

  @override
  void initState() {
    super.initState();
    _folderNameController = TextEditingController(text: widget.folderName);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(getFolderIcon(widget.folderName)),
      ),
      title: TextFormField(
        controller: _folderNameController,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FilesInFolderScreen(folderName: _folderNameController.text),
          ),
        );
      },
    );
  }

  String getFolderIcon(String folderName) {
    // Add logic to determine the icon based on the file extension
    // For now, let's assume folders have specific extensions
    if (folderName.endsWith('.pdf')) {
      return 'assets/aa.png'; // Replace with your PDF icon asset
    } else if (folderName.endsWith('.jpg') || folderName.endsWith('.jpeg')) {
      return 'assets/bb.png'; // Replace with your image icon asset
    } else if (folderName.endsWith('.txt')) {
      return 'assets/aa.png'; // Replace with your text file icon asset
    } else {
      return 'assets/bb.png'; // Default folder icon
    }
  }
}
