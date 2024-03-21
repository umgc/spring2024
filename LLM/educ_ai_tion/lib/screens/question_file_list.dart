import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:educ_ai_tion/widgets/custom_app_bar.dart';

class QuestionFileList extends StatefulWidget {
  const QuestionFileList({Key? key});

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
      String downloadUrl = await storageRef.child(fileName).getDownloadURL();

      // Open the download URL in a new browser tab
      if (await canLaunch(downloadUrl)) {
        await launch(downloadUrl);
      } else {
        throw 'Could not launch $downloadUrl';
      }
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
      //drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView.builder(
          itemCount: fileNames.length,
          itemBuilder: (context, index) {
            String fileName = fileNames[index];

            return ListTile(
              title: Text(fileName),
              trailing: TextButton(
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
