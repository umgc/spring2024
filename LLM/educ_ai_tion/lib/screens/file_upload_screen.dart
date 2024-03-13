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

List<String> _pickedFilePaths = [];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    
    if (result != null) {
         _pickedFilePaths.clear();
      try{
      for (var file in result.files) {
        final name = file.name;
        final path = file.path ?? '';

        // Simulate file upload
        await _storageService.uploadFile(name, path);
      }
      

      // Trigger UI update
      setState(() {});

      // Simulated upload feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded ${result.files.length} files')),
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading files: $e')),
      );
    }
   }
  }
  
  Future<void> _uploadToAI() async {
  
     if (_pickedFilePaths.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No files selected to upload to AI")),
    );
    return;
  }

  // Placeholder: Process each file for AI upload
  for (String filePath in _pickedFilePaths) {
    print("Uploading file to AI: $filePath");
    // Here, replace print with your logic to read the file and upload its content to the AI service
  }

  // Feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Uploaded ${_pickedFilePaths.length} files to AI")),
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
          Padding(
          padding:const EdgeInsets.all(8.0),
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
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _uploadToAI, // Make sure you've defined _uploadToAI method as shown earlier
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Use a distinct color for differentiation
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Upload to AI'),
          ),
        ),
        ],
      ),
    );
  }
}
 