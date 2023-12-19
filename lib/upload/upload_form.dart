import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:assignment_internshala/authentication_repo/authentication_repo.dart';
import 'package:assignment_internshala/explore_page.dart';
import 'package:assignment_internshala/upload/take_video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_compress_plus/video_compress_plus.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({
    super.key,
    required this.location,
    required this.videoFile,
    required this.videoPath,
   required this.videoLength,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  final location;
  final File videoFile;
  final String videoPath;
final String videoLength;
final  videoUrl;
final thumbnailUrl;

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  var address;
  User? user = FirebaseAuth.instance.currentUser;
  final _formkey2 = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final usernameController = TextEditingController();
  bool showProgressBar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData(widget.location);
    print(
        "========================================================>${widget.location['features'][0]['properties']['address_line2']}");
  }

  void setData(dynamic locationData) async {
    var tempadd =
        await locationData['features'][0]['properties']['address_line2'];
    setState(() {
      address = tempadd;
    });
    print("========================================================>$address");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              Form(
                key: _formkey2,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 8.0,
                      ),
                      child: Text(
                        "Thumbnail",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 200,
                          child: Image.network('${widget.thumbnailUrl}')
                        ),
                      ),
                    ),
                    const SizedBox(height: 8,),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 8.0,
                      ),
                      child: Text(
                        "Title",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: titleController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Video Title ";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "Video Title",
                            contentPadding: EdgeInsets.fromLTRB(24, 4, 12, 12),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 8.0,
                      ),
                      child: Text(
                        "Address",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          enabled: false,
                          maxLines: 3,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: "$address",
                            contentPadding:
                                const EdgeInsets.fromLTRB(24, 4, 12, 12),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        top: 8.0,
                      ),
                      child: Text(
                        "Category",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: categoryController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Category";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 1,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            hintText: "Category Name",
                            contentPadding: EdgeInsets.fromLTRB(24, 4, 12, 12),
                          ),
                          style: const TextStyle(
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    showProgressBar == true
                        ? Center(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 20,
                                sigmaY: 20,
                              ),
                              child:const SimpleCircularProgressBar(
                                progressColors: [
                                  Colors.green,
                                  Colors.blueAccent,
                                  Colors.red,
                                  Colors.amber,
                                  Colors.purpleAccent,
                                ],
                                animationDuration: 25,
                                backColor: Colors.white38,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 2,
                                        offset: Offset(2.4, 3.2)),
                                  ]),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await AuthenticationRepo.instance
                                      .addVideoToDb(
                                    titleController.text.trim(),
                                    categoryController.text.trim(),
                                    address,
                                    widget.videoUrl,
                                    widget.thumbnailUrl,
                                    widget.videoLength,
                                  );
                                  setState(() {
                                    showProgressBar = false;
                                  });
                                  Get.offAll(() =>  const ExplorePage());
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  fixedSize: const Size(368, 44),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  "Post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*compressVideoFile(String videoPath) async {
    final compressedvideoFile = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedvideoFile!.file;
  }

  getVideoThumbnail(String videoPath) {
    final thumbnailImage = VideoCompress.getFileThumbnail(videoPath);
   // giveThumbnail(thumbnailImage);

    return thumbnailImage;
  }

  uploadToStorage(File videoFile, String videoPath) async {
    setState(() {
      showProgressBar = true;
    });
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceVideoDir = referenceRoot.child("Videos");
    Reference referenceVideoToUpload = referenceVideoDir.child(uniqueName);

    try {
      await referenceVideoToUpload.putFile(compressVideoFile(videoPath));
      await uploadThumbnailToStorage(uniqueName, videoPath);
      videoUrl = await referenceVideoToUpload.getDownloadURL();
    } catch (e) {
      log("------------------------------->${e.toString()}");
    }
    return videoUrl;
  }

  uploadThumbnailToStorage(String uniqueName, String videoPath) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceThumbnailDir = referenceRoot.child("Thumbnails");
    Reference referenceThumbnailToUpload =
        referenceThumbnailDir.child(uniqueName);

    try {
      await referenceThumbnailToUpload.putFile(getVideoThumbnail(videoPath));
      thumbnailUrl = await referenceThumbnailToUpload.getDownloadURL();
    } catch (e) {
      log("------------------------------->${e.toString()}");
    }
    return thumbnailUrl;
  }

   Widget? giveThumbnail(File thumbnailImage) {
     getVideoThumbnail(widget.videoPath);
  }*/

}