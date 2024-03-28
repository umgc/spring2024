import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../services/file_service.dart';

class QuestionFileList extends StatefulWidget {
  @override
  _CombinedScreenState createState() => _CombinedScreenState();
}

class _CombinedScreenState extends State<QuestionFileList> {
  final Reference storageRef =
      FirebaseStorage.instance.ref().child('selected_questions');
  late List<String> fileNames = [];
  final FileStorageService _storageService = FileStorageService();
  Map<String, Uint8List> _pickedFilesBytes = {};
  Map<String, bool> _pickedFilesSelection = {};

  @override
  void initState() {
    super.initState();
    getFileNames();
  }

  Future<void> getFileNames() async {
    try {
      ListResult result = await storageRef.listAll();
      setState(() {
        fileNames = result.items.map((item) => item.name).toList();
      });
    } catch (e) {
      print('Error fetching file names: $e');
    }
  }

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
      await getFileNames();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'File Management', onMenuPressed: () {}),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2, // Takes half of the screen space
            child: ListView.builder(
              itemCount: fileNames.length,
              itemBuilder: (context, index) {
                String fileName = fileNames[index];
                return ListTile(
                  title: Text(fileName),
                  trailing: TextButton(
                    onPressed: () {}, // Add logic to download or view the file
                    child: Text('Download'),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 2.0, // Height of the separator line
            color: const Color.fromARGB(
                255, 137, 39, 176), // Color of the separator line
          ),
          Expanded(
            flex: 1, // Takes the other half of the screen space
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _pickedFilesSelection.length,
                    itemBuilder: (context, index) {
                      String fileName =
                          _pickedFilesSelection.keys.elementAt(index);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 4.0), // Add space between buttons
                          child: ElevatedButton(
                            onPressed: _pickFile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 92, 20, 224),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Pick a File'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0), // Add space between buttons
                          child: ElevatedButton(
                            onPressed: _uploadToAI,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 114, 76, 175),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text('Upload to Storage'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
