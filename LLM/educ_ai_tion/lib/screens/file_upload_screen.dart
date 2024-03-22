import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_service.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:typed_data';

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

    // Identify .txt files that were selected for upload
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
      setState(() {
        nonTxtFilesSelected.forEach(_pickedFiles.remove);
      });
    }

    if (filesToUpload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No valid files selected to upload")),
      );
      return; // No valid .txt files to upload, return early
    }

    int uploadCount = 0;

    try {
      for (String filePath in filesToUpload) {
        String fileName = path.basename(filePath); // Extract the file name
        Uint8List fileBytes =
            await File(filePath).readAsBytes(); // Read the file as bytes
        await _storageService.uploadFile(fileName, fileBytes); // Upload file
        // This feels redundant, but holding for eval
        //ScaffoldMessenger.of(context).showSnackBar(
        //  SnackBar(content: Text("Uploaded .txt file to Storage: $fileName")),
        //);
        uploadCount++;
        setState(() {
          _pickedFiles.remove(filePath);
        });
      }
    } catch (e) {
      // Display snackbar of error uploading file
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
    }

    // Notify the user about successful upload
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Uploaded $uploadCount .txt files to Storage")),
    );
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
              onPressed: _uploadToAI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
