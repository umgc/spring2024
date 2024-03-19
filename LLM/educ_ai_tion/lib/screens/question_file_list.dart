import 'dart:io';
import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class QuestionFileList extends StatefulWidget {
  const QuestionFileList({super.key});

  @override
  _FileListViewState createState() => _FileListViewState();
}

class _FileListViewState extends State<QuestionFileList> {
  final Reference storageRef =
      FirebaseStorage.instance.ref().child('selected_questions');

  late List<String> fileNames = [];

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

  Future<void> downloadFile(String fileName) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${(await directory).path}/$fileName';

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      File downloadFile = File(filePath);
      await storageRef.child(fileName).writeToFile(downloadFile);
      print('File downloaded successfully');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File downloaded to: $filePath'),
      ));
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved Questions List',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView.builder(
          itemCount: fileNames.length,
          itemBuilder: (context, index) {
            String fileName = fileNames[index];
            bool isFileDownloaded = File(
              '${(getApplicationDocumentsDirectory().then((dir) => dir.path))}/$fileName',
            ).existsSync();

            return ListTile(
              title: Text(fileName),
              trailing: isFileDownloaded
                  ? TextButton(
                      onPressed: () {},
                      child: Text(
                        'Downloaded',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  : TextButton(
                      onPressed: () => downloadFile(fileName),
                      child: Text('Download'),
                    ),
            );
          },
        ),
      ),
    );
  }
}
