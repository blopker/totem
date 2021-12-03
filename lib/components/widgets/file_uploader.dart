import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totem/components/widgets/busy_indicator.dart';
import 'package:totem/models/index.dart';
import 'package:totem/services/providers.dart';
import 'package:uuid/uuid.dart';

class FileUploader extends ConsumerStatefulWidget {
  const FileUploader({
    Key? key,
    this.onComplete,
    this.clearFile = false,
  }) : super(key: key);
  final ValueChanged<String?>? onComplete;
  final bool clearFile;

  @override
  FileUploaderState createState() => FileUploaderState();
}

class FileUploaderState extends ConsumerState<FileUploader> {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.UploadTask? _uploadTask;
  File? _uploadFile;
  Map<String, dynamic>? upload;
  String? uploadContext;

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<firebase_storage.TaskSnapshot>(
        stream: _uploadTask!.snapshotEvents,
        builder: (context, snapshot) {
          //var event = snapshot?.data?.snapshot;
          //double progressPercent = event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_uploadTask!.snapshot.state ==
                  firebase_storage.TaskState.running)
                const BusyIndicator(),
            ],
          );
        },
      );
    } else {
      return Container();
    }
  }

  Future<void> profileImageUpload(File upload, AuthUser user) async {
    const uuid = Uuid();
    try {
      firebase_storage.Reference ref =
          _storage.ref().child('user').child(user.uid).child(uuid.v1());

      setState(() {
        _uploadFile = upload;
        _uploadTask = ref.putFile(_uploadFile!);
      });
      firebase_storage.TaskSnapshot? snapshot = await _uploadTask;
      if (snapshot != null) {
        String url = await snapshot.ref.getDownloadURL();
        await _completeUpload(upload, url: url);
      }
    } on firebase_core.FirebaseException catch (e) {
      debugPrint(e.message);
      if (e.code == 'permission-denied') {
        debugPrint(
            'User does not have permission to upload to this reference.');
      }
    }
  }

  Future<void> _completeUpload(File upload, {String url = ''}) async {
    if (url.isNotEmpty) {
      var repo = ref.read(repositoryProvider);
      repo.updateUserProfileImage(url);
    }
    // await clearTemporaryFiles(upload);
    if (widget.onComplete != null) {
      widget.onComplete!(url);
    }
  }

  static Future<void> clearTemporaryFiles(File? upload) async {
    if (upload != null) {
      try {
        await upload.delete();
      } catch (ex) {
        debugPrint(ex.toString());
      }
    }
  }
}
