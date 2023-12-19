import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:assignment_internshala/upload/upload_form.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:video_compress_plus/video_compress_plus.dart';
import 'package:video_player/video_player.dart';


class UploadVideo extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const UploadVideo(
      {super.key, required this.videoFile, required this.videoPath,});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  VideoPlayerController? playerController;
  ChewieController? chewieController;
  bool showProgressBar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);

      chewieController = ChewieController(
        videoPlayerController: playerController!,
        aspectRatio: 9/16,
      );
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(0.65);
    playerController!.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chewieController!.dispose();
    playerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BlackCoffer",
                style: TextStyle(color: Colors.grey[400],
                    fontFamily: 'Satoshi',
                    fontSize: 16,),
              ),
              const Icon(
                Icons.notifications_active_outlined,
              )
            ],
          ),
        ),
        body:Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 740,child:Chewie(controller: chewieController!)),
                //CircularProgressIndicator()
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 48,width: 92,decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),child: ElevatedButton(onPressed: (){
                          /* widget.videoFile.delete();*/
                          Navigator.of(context).pop();
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 12,),
                            Text("Retry",style: TextStyle(fontSize: 12,
                                fontFamily: 'Satoshi',
                                color: Colors.white),),

                          ],
                        ),)),
                      ),
                    ),


                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(height: 48,width: 92,decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),child: ElevatedButton(onPressed: () async {
                          String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
                          playerController!.pause();
                          String videoDownloadUrl = await uploadToStorage(uniqueName,widget.videoPath);
                          String thumbnailDownloadUrl = await uploadThumbnailToStorage(uniqueName, widget.videoPath);
                          getData(videoDownloadUrl,thumbnailDownloadUrl);
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Next",style: TextStyle(fontSize: 12,
                                fontFamily: 'Satoshi',
                                color: Colors.white),),
                            Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 12,)
                          ],
                        ),)),
                      ),
                    ),
                  ],
                )



              ],
            ),
            Visibility(
              visible: showProgressBar == true,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child:const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Center(
                      child: SimpleCircularProgressBar(
                        progressStrokeWidth: 6,
                      backStrokeWidth: 6,
                      size: 72,
                      progressColors: [
                        Colors.green,
                        Colors.blueAccent,
                        Colors.red,
                        Colors.amber,
                        Colors.purpleAccent,
                      ],
                      animationDuration: 16,
                      backColor: Colors.white38,
                  ),
                    ),
                    SizedBox(height: 12,),
                    Text("Touching Up Your Video",   style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 12,
                        color: Colors.white60),),
                ]
                ),
              ),
            ),
          ],
        )


      ),
    );
  }

  compressVideoFile(String videoPath) async {
    final compressedvideoFile = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.LowQuality);
    return compressedvideoFile!.file;
  }

  getVideoThumbnail(String videoPath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoPath) ;
    // giveThumbnail(thumbnailImage);

    return thumbnailImage;
  }

  uploadToStorage(String uniqueName, String videoPath) async {
    setState(() {
      showProgressBar = true;
    });
   /* String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();*/
  /*  Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceVideoDir = referenceRoot.child("Videos");
    Reference referenceVideoToUpload = referenceVideoDir.child(uniqueName);*/

    UploadTask referenceVideoToUpload = FirebaseStorage.instance.ref()
        .child("Videos")
        .child(uniqueName)
        .putFile(await compressVideoFile(videoPath));

    TaskSnapshot snapshot = await referenceVideoToUpload;

    String downloadUrlOfVideo = await snapshot.ref.getDownloadURL();
    log("--------------------------------------------->Download video url === $downloadUrlOfVideo}");
    return downloadUrlOfVideo;

    /*  try {
     // await referenceVideoToUpload.putFile(videoFile);
      await uploadThumbnailToStorage(uniqueName, videoPath);
      videoUrl = await referenceVideoToUpload.getDownloadURL();
    } catch (e) {
      log("------------------------------->video upload error :- ${e.toString()}");
    }*/
  }

  uploadThumbnailToStorage(String uniqueName, String videoPath) async {

    UploadTask referenceThumbnailToUpload = FirebaseStorage.instance.ref()
        .child("Thumbnails")
        .child(uniqueName)
        .putFile(await getVideoThumbnail(videoPath));

    TaskSnapshot snapshot = await referenceThumbnailToUpload;

    String downloadUrlOfThumbnail = await snapshot.ref.getDownloadURL();
    log("--------------------------------------------->Download thumbnail url === $downloadUrlOfThumbnail}");
    return downloadUrlOfThumbnail;

    /* Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceThumbnailDir = referenceRoot.child("Thumbnails");
    Reference referenceThumbnailToUpload =
    referenceThumbnailDir.child(uniqueName);

    try {
      await referenceThumbnailToUpload.putFile(await getVideoThumbnail(videoPath));
      thumbnailUrl = await referenceThumbnailToUpload.getDownloadURL() as String;
      log("------------------------------------------------>Your ThumbnailUrl :- $thumbnailUrl");
    } catch (e) {
      log("------------------------------->thumbnail upload error:- ${e.toString()}");
    }*/

  }

  getData(String videoDownloadUrl,String thumbnailDownloadUrl ,) async
  {
    await Geolocator.requestPermission();
    await Geolocator.checkPermission();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latitude = position.latitude;
    var longitude = position.longitude;
    http.Response response = await http.get(Uri.parse("https://api.geoapify.com/v1/geocode/reverse?lat=$latitude&lon=$longitude&apiKey=06a0d6f27f91489b915016e74a67be67"));

    String data = response.body;
    var decodedData = jsonDecode(data);
    print("------------------------------------------------------${decodedData['features'][0]['properties']['address_line2']}");
    print("---------------------------------${response.statusCode}");
    if(response.statusCode == 200 && videoDownloadUrl.isNotEmpty && thumbnailDownloadUrl.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return UploadForm(
          location: decodedData,
          videoFile: widget.videoFile,
          videoPath: widget.videoPath,
          videoLength: playerController!.value.duration.inSeconds.toString(),videoUrl: videoDownloadUrl, thumbnailUrl:thumbnailDownloadUrl);
      },));
    }
    else{
      return const Text("error occured");
    }
//return decodedData;/*jsonDecode(response.body)['country'];*/

  }
}

