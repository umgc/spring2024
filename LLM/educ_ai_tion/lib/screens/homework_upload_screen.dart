import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_service.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart'; 
// File Upload Screen

// This screen facilitates the uploading of files by the user. It is designed to accept test templates or other educational materials.
// The uploaded files can then be processed or stored by the application, enabling teachers to work with their existing documents or templates.

class HomeworkUpload extends StatefulWidget {
  const HomeworkUpload({Key? key}) : super(key: key);
  @override
  _HomeworkUploadState createState() => _HomeworkUploadState();
}

class _HomeworkUploadState extends State<HomeworkUpload> {
  final FileStorageService _storageService = FileStorageService();

  // Store file names and their bytes
  Map<String, Uint8List> _pickedFilesBytes = {};
  Map<String, bool> _pickedFilesSelection = {};

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.any, // Keep this to allow any file type
    );

    if (result != null) {
      for (var file in result.files) {
        final fileName = file.name ?? '';
        if (!_pickedFilesSelection.containsKey(fileName)) {
          _pickedFilesSelection[fileName] = false;
          _pickedFilesBytes[fileName] = file.bytes!;
        }
      }

      setState(() {});
    }
  }

  Future<void> _uploadToAI() async {
    if (_pickedFilesSelection.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No files selected")),
      );
      return;
    }

    var filesToUpload = _pickedFilesSelection.keys
        .where((name) => _pickedFilesSelection[name]!)
        .toList();

    if (filesToUpload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No files selected to upload")),
      );
      return;
    }

    try {
      for (String fileName in filesToUpload) {
        Uint8List fileBytes =
            _pickedFilesBytes[fileName]!; // Use bytes directly
        await _storageService.uploadFile(fileName, fileBytes); // Upload file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Uploaded file to Storage: $fileName")),
        );
        setState(() {
          _pickedFilesSelection.remove(fileName);
          _pickedFilesBytes.remove(fileName);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
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
              itemCount: _pickedFilesSelection.length,
              itemBuilder: (context, index) {
                String fileName = _pickedFilesSelection.keys.elementAt(index);
                return CheckboxListTile(
                  title: Text(fileName),
                  value: _pickedFilesSelection[fileName],
                  onChanged: (bool? value) {
                    setState(() {
                      _pickedFilesSelection[fileName] = value!;
                    });
                  },
                  secondary: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _pickedFilesSelection.remove(fileName);
                        _pickedFilesBytes.remove(fileName);
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
        ],
      ),
    );
  }
}
