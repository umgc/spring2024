import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_service.dart';
import 'dart:io';

// File Upload Screen
//
// This screen facilitates the uploading of files by the user. It is designed to accept test templates or other educational materials.
// The uploaded files can then be processed or stored by the application, enabling teachers to work with their existing documents or templates.

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final FileStorageService _storageService = FileStorageService();

  // Store file paths and selection status
  Map<String, bool> _pickedFiles = {};

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // Update _pickedFiles with new selections, maintaining previous selections
      for (var file in result.files) {
        final path = file.path ?? '';
        if (!_pickedFiles.containsKey(path)) {
          // Avoid overriding selections on re-picking
          _pickedFiles[path] = false; // Add new file as not selected by default
        }
      }

      setState(() {}); // Refresh UI to display newly picked files
    }
  }

  Future<void> _uploadToAI() async {
    if (_pickedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No files selected")),
      );
      return;
    }

    // Filter out files that are marked for upload and are .txt files
    var filesToUpload = _pickedFiles.keys
        .where((path) =>
            _pickedFiles[path]! && path.toLowerCase().endsWith('.txt'))
        .toList();

    // Identify non-.txt files that were selected for upload
    var nonTxtFilesSelected = _pickedFiles.keys
        .where((path) =>
            _pickedFiles[path]! && !path.toLowerCase().endsWith('.txt'))
        .toList();

    if (nonTxtFilesSelected.isNotEmpty) {
      // Notify the user that non-.txt files cannot be uploaded
      String nonTxtFileNames =
          nonTxtFilesSelected.map((e) => e.split('/').last).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Only .txt files are allowed. These files were not uploaded: $nonTxtFileNames")),
      );
    }

    if (filesToUpload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No files selected")),
      );
      return; // No valid .txt files to upload, return early
    }

    // Implement your upload logic here for filesToUpload
    for (String filePath in filesToUpload) {
      String fileName = filePath.split('/').last;
      await _storageService.uploadFile(fileName, filePath);
      print("Uploading file to AI: $filePath");
    }

    // clear uploaded file list
    setState(() {
      _pickedFiles.clear();
    });

    // Notify the user about successful upload
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Uploaded ${filesToUpload.length} files to Storage")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Upload Content',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _pickedFiles.length,
              itemBuilder: (context, index) {
                String filePath = _pickedFiles.keys.elementAt(index);
                String fileName = filePath.split('/').last;
                return CheckboxListTile(
                  title: Text(fileName),
                  value: _pickedFiles[filePath],
                  onChanged: (bool? value) {
                    setState(() {
                      _pickedFiles[filePath] = value!;
                    });
                  },
                  secondary: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _pickedFiles.remove(filePath);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
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
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:
                  _uploadToAI, // Make sure you've defined _uploadToAI method as shown earlier
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Use a distinct color for differentiation
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Upload to Storage'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Upload restricted to .txt files',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
