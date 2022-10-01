import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video_model.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  //upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    //
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      //get id
      var allDocs = await firestore.collection('videos').get();

      int len = allDocs.docs.length;

      String videoUrl = await _uploadVideoToStorage('Video_$len', videoPath);

      String thumbnailUrl =
          await _uploadImageToStorage('Video_$len', videoPath);

      Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: 'Video_$len',
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnailUrl: thumbnailUrl,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto']);

      await firestore
          .collection('videos')
          .doc('Video_$len')
          .set(video.toJson());

      Get.back();
    } catch (e) {
      //Error
      Get.snackbar('Error uploading video', e.toString());
    }
  }

  //Upload video to Firebase Storage and return the download URL
  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    //
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  //Compress the video and return the compressed file
  Future<dynamic> _compressVideo(String videoPath) async {
    //
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );

    return compressedVideo!.file;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    //
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<dynamic> _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }
}
