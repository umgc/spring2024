import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

// File Upload Screen
// 
// This screen facilitates the uploading of files by the user. It is designed to accept test templates or other educational materials. 
// The uploaded files can then be processed or stored by the application, enabling teachers to work with their existing documents or templates.

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

  void _uploadFile() {
    // Implement file upload functionality
    // For now, we just display a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploading $_fileName')),
    );
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick File'),
            ),
            const SizedBox(height: 20),
            Text(_fileName ?? 'No file selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _filePath != null ? _uploadFile : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: _filePath != null ? Colors.blue : Colors.grey,
              ),
              child: const Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
