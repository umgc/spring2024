import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_service.dart';

// File Upload Screen
// 
// This screen facilitates the uploading of files by the user. It is designed to accept test templates or other educational materials. 
// The uploaded files can then be processed or stored by the application, enabling teachers to work with their existing documents or templates.

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final FileStorageService _storageService = FileStorageService();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final name = result.files.single.name;
      final path = result.files.single.path ?? '';

      // Simulate file upload
      await _storageService.uploadFile(name, path);

      // Trigger UI update
      setState(() {});

      // Simulated upload feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded $name')),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Content'),
        backgroundColor: Colors.blue[700],

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _storageService.uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = _storageService.uploadedFiles[index];
                return ListTile(
                  title: Text(file['name']!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _storageService.deleteFile(file['name']!);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: _pickFile,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            child: const Text('Pick a File'),
            )
          ),
        ],
      ),
    );
  }
}
 